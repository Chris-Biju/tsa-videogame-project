extends Node
## Autoload: the current playthrough's data and the rules that change it.
##
## How the scenes fit together:
##   - ContentDB holds definitions (building costs, quests, events, classes).
##   - GameState (this file) holds the current save and applies the rules.
##   - Screens READ from GameState and send REQUESTS to it (try_place_building,
##     accept_quest, advance_week, ...). They never change each other directly.
##   - Whenever data changes, GameState emits state_changed and every open
##     screen redraws itself from GameState.

signal state_changed
signal notification_requested(message: String)
signal level_up(new_level: int, bonus_name: String, bonus_amount: float)

## Quest objective types the game can currently check and complete.
## Add a type here once the system for it exists (puzzles, choices, ...).
const SUPPORTED_QUEST_TYPES: Array[String] = ["build", "deliver", "spend_resources"]

const STATUS_OPERATIONAL := "operational"
const STATUS_DAMAGED := "damaged"
const STATUS_UNSTABLE := "unstable"

var has_started: bool = false

# Week and remaining time
var current_week: int = 1
var total_weeks: int = 52

# Resources, keyed by ContentDB.RESOURCES ids ("kristals", "oxygen", ...)
var resources: Dictionary = {}
var population: int = 0
var morale: int = 100

# Leader
var selected_character: String = ""
var level: int = 1
var xp: int = 0
var stats: Dictionary = {}

# Colony
## Placed building instances: {uid, building_id, position, status, built_week}.
## The definition (cost, output, ...) always comes from ContentDB.
var buildings: Array[Dictionary] = []
var next_building_uid: int = 1
var researched_techs: Array[String] = []
var terraform_progress: float = 0.0

# Quests and events
## Accepted villager quests plus this week's Risium quota.
var active_quests: Array[Dictionary] = []
## Completed and failed quests, newest last.
var finished_quests: Array[Dictionary] = []
## The event rolled at the start of the current week ({} if none).
var current_event: Dictionary = {}
var week_reports: Array[Dictionary] = []


# ---------------------------------------------------------------------------
# New game
# ---------------------------------------------------------------------------

func start_new_game(class_id: String) -> void:
	var start: Dictionary = ContentDB.STARTING_STATE
	var player_class: Dictionary = ContentDB.get_player_class(class_id)

	has_started = true
	current_week = 1
	total_weeks = int(start.get("total_weeks", 52))
	population = int(start.get("population", 0))
	morale = int(start.get("morale", 100))

	resources.clear()
	for resource_id in ContentDB.RESOURCES:
		resources[resource_id] = int(start.get("resources", {}).get(resource_id, 0))
	_add_resources(player_class.get("starting_bonus", {}))

	selected_character = class_id
	level = 1
	xp = 0
	stats = player_class.get("starting_stats", {}).duplicate(true)

	buildings.clear()
	next_building_uid = 1
	researched_techs.clear()
	terraform_progress = 0.0

	active_quests.clear()
	finished_quests.clear()
	current_event = {}
	week_reports.clear()
	active_quests.append(_make_quota_quest(current_week))

	state_changed.emit()


## Lets a screen be run on its own (F6) for testing without going through
## character select first.
func start_preview_game_if_needed() -> void:
	if not has_started:
		start_new_game(ContentDB.PLAYER_CLASSES[0]["id"])


func is_game_over() -> bool:
	return has_started and current_week > total_weeks


# ---------------------------------------------------------------------------
# Resources
# ---------------------------------------------------------------------------

func get_resource(resource_id: String) -> int:
	return int(resources.get(resource_id, 0))


func can_afford(cost: Dictionary) -> bool:
	return get_missing_resources(cost).is_empty()


## Returns {resource_id: amount_still_needed} for everything the colony lacks.
func get_missing_resources(cost: Dictionary) -> Dictionary:
	var missing: Dictionary = {}
	for resource_id in cost:
		var shortfall: int = int(cost[resource_id]) - get_resource(resource_id)
		if shortfall > 0:
			missing[resource_id] = shortfall
	return missing


func _spend(cost: Dictionary) -> void:
	for resource_id in cost:
		resources[resource_id] = get_resource(resource_id) - int(cost[resource_id])


func _add_resources(amounts: Dictionary) -> void:
	for resource_id in amounts:
		resources[resource_id] = get_resource(resource_id) + int(amounts[resource_id])


## Applies a reward/penalty dictionary. Keys can be resource ids, "morale",
## "population" or "xp".
func apply_effects(effects: Dictionary) -> void:
	for key in effects:
		var amount: int = int(effects[key])
		match key:
			"morale":
				change_morale(amount)
			"population":
				population = max(0, population + amount)
			"xp":
				add_xp(amount)
			_:
				resources[key] = max(0, get_resource(key) + amount)


func change_morale(amount: int) -> void:
	morale = clampi(morale + amount, 0, 100)


# ---------------------------------------------------------------------------
# Buildings
# ---------------------------------------------------------------------------

func is_in_bounds(position: Vector2i) -> bool:
	return position.x >= 0 and position.y >= 0 \
		and position.x < ContentDB.MAP_COLUMNS and position.y < ContentDB.MAP_ROWS


func get_terrain(_position: Vector2i) -> String:
	# Every tile is flat for now. Store per-tile terrain here when terrain rules exist.
	return ContentDB.DEFAULT_TERRAIN


func get_building_at(position: Vector2i) -> Dictionary:
	for instance in buildings:
		if instance["position"] == position:
			return instance
	return {}


func count_buildings(building_id: String) -> int:
	var count: int = 0
	for instance in buildings:
		if instance["building_id"] == building_id:
			count += 1
	return count


func get_housing_capacity() -> int:
	var capacity: int = 0
	for instance in buildings:
		var definition: Dictionary = ContentDB.get_building_by_id(instance["building_id"])
		capacity += _num(definition.get("housing_capacity"))
	return capacity


func is_building_unlocked(building_id: String) -> bool:
	return get_required_tech(building_id).is_empty()


## Returns the tech that still has to be researched to build this ({} if none).
func get_required_tech(building_id: String) -> Dictionary:
	for tech in ContentDB.TECHNOLOGIES:
		if building_id in tech.get("unlocks", []) and tech["id"] not in researched_techs:
			return tech
	return {}


## Returns "" if the building can be placed on the tile, otherwise the reason it can't.
## Pass Vector2i(-1, -1) to only check the building itself (used by the build menu).
func get_build_block_reason(building_id: String, position: Vector2i) -> String:
	var definition: Dictionary = ContentDB.get_building_by_id(building_id)
	if definition.is_empty():
		return "Unknown building."
	if definition.get("cost_tbd", false):
		return "Cost not designed yet."
	var required_tech: Dictionary = get_required_tech(building_id)
	if not required_tech.is_empty():
		return "Requires research: %s." % required_tech.get("name", "")
	if position != Vector2i(-1, -1):
		if not is_in_bounds(position):
			return "That tile is outside the colony."
		if not get_building_at(position).is_empty():
			return "That tile already has a building."
	var missing: Dictionary = get_missing_resources(definition.get("cost", {}))
	if not missing.is_empty():
		return "Need %s more." % ContentDB.format_cost(missing)
	return ""


## Request from the colony screen. Returns true if the building was placed.
func try_place_building(building_id: String, position: Vector2i) -> bool:
	var reason: String = get_build_block_reason(building_id, position)
	if reason != "":
		notify(reason)
		return false

	var definition: Dictionary = ContentDB.get_building_by_id(building_id)
	_spend(definition.get("cost", {}))
	buildings.append({
		"uid": next_building_uid,
		"building_id": building_id,
		"position": position,
		"status": STATUS_OPERATIONAL,
		"built_week": current_week
	})
	next_building_uid += 1

	# Shops and similar buildings give their morale bonus once, when built.
	change_morale(_num(definition.get("morale_change")))
	notify("Built %s." % definition.get("name", building_id))
	_on_building_built(building_id)
	add_xp(ContentDB.BUILD_XP)
	state_changed.emit()
	return true


func get_repair_cost(instance: Dictionary) -> Dictionary:
	var definition: Dictionary = ContentDB.get_building_by_id(instance.get("building_id", ""))
	var repair_cost: Dictionary = {}
	for resource_id in definition.get("cost", {}):
		repair_cost[resource_id] = int(ceil(int(definition["cost"][resource_id]) * ContentDB.REPAIR_COST_FRACTION))
	return repair_cost


## Request from the colony panel. Fixes a damaged or unstable building.
func try_repair_building(position: Vector2i) -> bool:
	var instance: Dictionary = get_building_at(position)
	if instance.is_empty() or instance["status"] == STATUS_OPERATIONAL:
		notify("Nothing to repair here.")
		return false
	var cost: Dictionary = get_repair_cost(instance)
	var missing: Dictionary = get_missing_resources(cost)
	if not missing.is_empty():
		notify("Repair needs %s more." % ContentDB.format_cost(missing))
		return false
	_spend(cost)
	instance["status"] = STATUS_OPERATIONAL
	notify("Repaired %s." % ContentDB.get_building_by_id(instance["building_id"]).get("name", ""))
	state_changed.emit()
	return true


## What each operational building produces per week: {resource_id: amount}.
func get_weekly_production() -> Dictionary:
	var production: Dictionary = {}
	for instance in buildings:
		if instance["status"] != STATUS_OPERATIONAL:
			continue
		var definition: Dictionary = ContentDB.get_building_by_id(instance["building_id"])
		# Economic output is paid in Kristals.
		var output: int = _num(definition.get("output_per_week"))
		if output > 0:
			production["kristals"] = int(production.get("kristals", 0)) + output
		var produced_resource: String = str(definition.get("resource_produced", ""))
		var amount: int = _num(definition.get("production_per_week"))
		if produced_resource != "" and amount > 0:
			production[produced_resource] = int(production.get(produced_resource, 0)) + amount
	return production


# ---------------------------------------------------------------------------
# Research
# ---------------------------------------------------------------------------

func get_research_block_reason(tech_id: String) -> String:
	var tech: Dictionary = ContentDB.get_technology_by_id(tech_id)
	if tech.is_empty():
		return "Unknown technology."
	if tech_id in researched_techs:
		return "Already researched."
	if tech.get("cost_tbd", false):
		return "Cost not designed yet."
	var missing: Dictionary = get_missing_resources(tech.get("cost", {}))
	if not missing.is_empty():
		return "Need %s more." % ContentDB.format_cost(missing)
	return ""


func try_research(tech_id: String) -> bool:
	var reason: String = get_research_block_reason(tech_id)
	if reason != "":
		notify(reason)
		return false
	var tech: Dictionary = ContentDB.get_technology_by_id(tech_id)
	_spend(tech.get("cost", {}))
	researched_techs.append(tech_id)
	notify("Researched %s." % tech.get("name", tech_id))
	add_xp(ContentDB.RESEARCH_XP)
	state_changed.emit()
	return true


# ---------------------------------------------------------------------------
# Quests
# ---------------------------------------------------------------------------

func _make_quota_quest(week: int) -> Dictionary:
	var quest: Dictionary = ContentDB.make_risium_quest(week)
	quest["kind"] = "quota"
	quest["status"] = "active"
	quest["accepted_week"] = week
	quest["deadline_week"] = week
	return quest


func get_quota_quest() -> Dictionary:
	for quest in active_quests:
		if quest.get("kind", "") == "quota":
			return quest
	return {}


func is_quest_active(quest_id: String) -> bool:
	for quest in active_quests:
		if quest.get("id", "") == quest_id:
			return true
	return false


## A quest can be offered if the game can check its objective right now.
func is_quest_offerable(quest: Dictionary) -> bool:
	if quest.get("objective_type", "") not in SUPPORTED_QUEST_TYPES:
		return false
	if is_quest_active(quest.get("id", "")):
		return false
	if quest.get("objective_type", "") == "build":
		var target: String = str(quest.get("target", ""))
		var definition: Dictionary = ContentDB.get_building_by_id(target)
		if definition.is_empty() or definition.get("cost_tbd", false):
			return false
	return true


## Picks this week's villager request. Prefers quests the player hasn't seen yet.
func get_next_quest_offer() -> Dictionary:
	var seen_ids: Array = []
	for quest in finished_quests:
		seen_ids.append(quest.get("id", ""))
	var fresh: Array[Dictionary] = []
	var repeatable: Array[Dictionary] = []
	for quest in ContentDB.VILLAGER_QUESTS:
		if not is_quest_offerable(quest):
			continue
		if quest["id"] in seen_ids:
			repeatable.append(quest)
		else:
			fresh.append(quest)
	var pool: Array[Dictionary] = fresh if not fresh.is_empty() else repeatable
	if pool.is_empty():
		return {}
	return pool.pick_random().duplicate(true)


func accept_quest(quest: Dictionary) -> void:
	if quest.is_empty() or is_quest_active(quest.get("id", "")):
		return
	var accepted: Dictionary = quest.duplicate(true)
	accepted["kind"] = "villager"
	accepted["status"] = "active"
	accepted["progress"] = 0
	accepted["accepted_week"] = current_week
	accepted["deadline_week"] = current_week + int(quest.get("deadline_weeks", 0))
	active_quests.append(accepted)
	notify("Quest accepted: %s" % accepted.get("title", ""))
	state_changed.emit()


func decline_quest(quest: Dictionary) -> void:
	notify("Declined: %s" % quest.get("title", ""))


func get_weeks_left(quest: Dictionary) -> int:
	return int(quest.get("deadline_week", current_week)) - current_week


## Resources the player hands over to finish a deliver/spend quest ({} if none).
func get_quest_inputs(quest: Dictionary) -> Dictionary:
	match quest.get("objective_type", ""):
		"deliver":
			return {quest.get("target", ""): int(quest.get("amount", 0))}
		"spend_resources":
			return quest.get("inputs", {})
	return {}


## Returns "" if the player can finish this quest from the quest screen right now.
## The Risium quota is delivered automatically at the end of the week.
func get_quest_complete_block_reason(quest: Dictionary) -> String:
	if quest.get("kind", "") == "quota":
		return "Delivered automatically when the week ends."
	if quest.get("status", "") != "active":
		return "This quest is no longer active."
	match quest.get("objective_type", ""):
		"build":
			return "Build the required building on the colony map."
		"deliver", "spend_resources":
			var missing: Dictionary = get_missing_resources(get_quest_inputs(quest))
			if not missing.is_empty():
				return "Need %s more." % ContentDB.format_cost(missing)
			return ""
	return "This objective can't be completed yet."


func try_complete_quest(quest_id: String) -> bool:
	for quest in active_quests:
		if quest.get("id", "") != quest_id:
			continue
		var reason: String = get_quest_complete_block_reason(quest)
		if reason != "":
			notify(reason)
			return false
		_spend(get_quest_inputs(quest))
		_finish_quest(quest, true)
		state_changed.emit()
		return true
	return false


func _on_building_built(building_id: String) -> void:
	for quest in active_quests.duplicate():
		if quest.get("objective_type", "") == "build" and quest.get("target", "") == building_id:
			quest["progress"] = int(quest.get("progress", 0)) + 1
			if quest["progress"] >= int(quest.get("amount", 1)):
				_finish_quest(quest, true)


func _finish_quest(quest: Dictionary, succeeded: bool) -> void:
	active_quests.erase(quest)
	quest["status"] = "completed" if succeeded else "failed"
	quest["finished_week"] = current_week
	finished_quests.append(quest)
	if quest.get("kind", "") == "quota":
		apply_effects(ContentDB.QUOTA_SUCCESS_EFFECTS if succeeded else ContentDB.QUOTA_FAILURE_EFFECTS)
	elif succeeded:
		apply_effects(quest.get("reward_effects", {}))
		add_xp(ContentDB.QUEST_COMPLETION_XP)
	else:
		apply_effects(ContentDB.QUEST_FAILURE_EFFECTS)
	if succeeded:
		notify("Quest complete: %s" % quest.get("title", ""))
	else:
		notify("Quest failed: %s" % quest.get("title", ""))


# ---------------------------------------------------------------------------
# Leveling
# ---------------------------------------------------------------------------

func xp_to_next_level() -> int:
	return ContentDB.XP_PER_LEVEL * level


func add_xp(amount: int) -> void:
	if amount <= 0:
		return
	xp += amount
	while xp >= xp_to_next_level():
		xp -= xp_to_next_level()
		level += 1
		var player_class: Dictionary = ContentDB.get_player_class(selected_character)
		var primary_stat: String = str(player_class.get("primary_stat", ""))
		if primary_stat != "":
			stats[primary_stat] = int(stats.get(primary_stat, 0)) + 1
		var bonus: Dictionary = player_class.get("level_bonus", {})
		level_up.emit(level, str(bonus.get("name", "Bonus")), float(bonus.get("amount", 0.0)))
	state_changed.emit()


# ---------------------------------------------------------------------------
# Week resolution (runs when the player presses End Week)
# ---------------------------------------------------------------------------

## Returns "" if the week can end, otherwise why not (e.g. an unresolved emergency).
func get_week_block_reason() -> String:
	if not has_started:
		return "No game in progress."
	if is_game_over():
		return "The colony's deadline has passed."
	return ""


## Resolves the current week in a fixed order and returns a report for the
## ResourceReport screen. Then starts the next week and rolls its event.
func advance_week() -> Dictionary:
	var report: Dictionary = {"week": current_week, "lines": []}
	var lines: Array = report["lines"]

	# 1. Production from buildings and outside support.
	var income: Dictionary = get_weekly_production()
	for resource_id in ContentDB.WEEKLY_SUPPLY:
		if current_event.get("effect_type", "") == "pause_external_delivery" \
				and current_event.get("resource", "") == resource_id:
			lines.append("No outside %s arrived (%s)." % [ContentDB.get_resource_name(resource_id), current_event.get("title", "")])
			continue
		income[resource_id] = int(income.get(resource_id, 0)) + int(ContentDB.WEEKLY_SUPPLY[resource_id])
	_add_resources(income)
	report["income"] = income
	lines.append("Income: %s" % ContentDB.format_cost(income))

	# 2. Upkeep. Shortages hurt morale.
	var upkeep: Dictionary = ContentDB.WEEKLY_UPKEEP
	lines.append("Upkeep: %s" % ContentDB.format_cost(upkeep))
	for resource_id in upkeep:
		var needed: int = int(upkeep[resource_id])
		if get_resource(resource_id) < needed:
			lines.append("Shortage of %s! Morale %d." % [ContentDB.get_resource_name(resource_id), -ContentDB.SHORTAGE_MORALE_PENALTY])
			change_morale(-ContentDB.SHORTAGE_MORALE_PENALTY)
		resources[resource_id] = max(0, get_resource(resource_id) - needed)

	# 3. Risium quota for this week.
	var quota: Dictionary = get_quota_quest()
	if not quota.is_empty():
		var amount: int = int(quota.get("amount", 0))
		if get_resource("risium") >= amount:
			_spend({"risium": amount})
			_finish_quest(quota, true)
			lines.append("Risium quota met: delivered %d. %s" % [amount, ContentDB.format_effects(ContentDB.QUOTA_SUCCESS_EFFECTS)])
		else:
			_finish_quest(quota, false)
			lines.append("Risium quota MISSED (needed %d, had %d). %s" % [amount, get_resource("risium"), ContentDB.format_effects(ContentDB.QUOTA_FAILURE_EFFECTS)])

	# 4. Quest deadlines.
	for quest in active_quests.duplicate():
		if get_weeks_left(quest) <= 0:
			_finish_quest(quest, false)
			lines.append("Quest expired: %s" % quest.get("title", ""))

	# 5. Start the next week: new quota, new event.
	current_week += 1
	if is_game_over():
		lines.append("The Empire's deadline has arrived.")
		current_event = {}
	else:
		active_quests.append(_make_quota_quest(current_week))
		_roll_weekly_event()
		if not current_event.is_empty():
			lines.append("New event: %s" % current_event.get("title", ""))

	report["event"] = current_event
	week_reports.append(report)
	state_changed.emit()
	return report


func _roll_weekly_event() -> void:
	var excluded: Array = []
	if not current_event.is_empty():
		excluded.append(current_event.get("id", ""))
	current_event = ContentDB.get_random_weekly_event(excluded)
	if current_event.is_empty():
		return
	# Apply the event right away so damage shows up before next week's production.
	current_event["result"] = _apply_event(current_event)


## Applies an event's immediate effect and returns a sentence describing it.
func _apply_event(event: Dictionary) -> String:
	match event.get("effect_type", ""):
		"pause_external_delivery":
			return "No outside %s will arrive this week." % ContentDB.get_resource_name(event.get("resource", ""))
		"destabilize_building":
			return _break_random_building(STATUS_UNSTABLE, str(event.get("target_category", "")))
		"damage_building":
			return _break_random_building(STATUS_DAMAGED, "")
		"workforce_disruption":
			var change: int = int(event.get("morale_change", 0))
			change_morale(change)
			return "Morale %+d." % change
		"discover_deposit":
			# TODO: mark a tile as a deposit once terrain/deposit rules exist.
			return event.get("effect_description", "")
	return event.get("effect_description", "")


func _break_random_building(new_status: String, category: String) -> String:
	var candidates: Array[Dictionary] = []
	for instance in buildings:
		if instance["status"] != STATUS_OPERATIONAL:
			continue
		var definition: Dictionary = ContentDB.get_building_by_id(instance["building_id"])
		if category == "" or definition.get("category", "") == category:
			candidates.append(instance)
	if candidates.is_empty():
		return "Luckily, no buildings were affected."
	var target: Dictionary = candidates.pick_random()
	target["status"] = new_status
	var building_name: String = ContentDB.get_building_by_id(target["building_id"]).get("name", "")
	return "%s at tile %d, %d is %s and stops producing until repaired." % [building_name, target["position"].x, target["position"].y, new_status]


# ---------------------------------------------------------------------------
# UI helpers
# ---------------------------------------------------------------------------

func notify(message: String) -> void:
	notification_requested.emit(message)


## Everything the TopBar shows, in one dictionary.
func get_status() -> Dictionary:
	var status: Dictionary = resources.duplicate()
	status["current_week"] = current_week
	status["remaining_weeks"] = max(0, total_weeks - current_week)
	status["population"] = population
	status["housing"] = get_housing_capacity()
	status["morale"] = morale
	status["level"] = level
	status["xp"] = xp
	status["xp_needed"] = xp_to_next_level()
	status["terraform_progress"] = terraform_progress
	status["warning"] = get_warning()
	return status


## The most urgent problem to show in the top bar ("" if none).
func get_warning() -> String:
	var quota: Dictionary = get_quota_quest()
	if not quota.is_empty() and get_resource("risium") < int(quota.get("amount", 0)):
		return "Quota: need %d Risium!" % int(quota.get("amount", 0))
	for resource_id in ContentDB.WEEKLY_UPKEEP:
		if get_resource(resource_id) < int(ContentDB.WEEKLY_UPKEEP[resource_id]):
			return "%s running out!" % ContentDB.get_resource_name(resource_id)
	if morale < 30:
		return "Morale is dangerously low!"
	return ""


## ContentDB uses null for values that aren't designed yet; treat those as 0.
func _num(value) -> int:
	return 0 if value == null else int(value)
