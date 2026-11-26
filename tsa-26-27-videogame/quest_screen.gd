extends Control
## Quest log. Lists GameState.active_quests (this week's Risium quota plus
## accepted villager requests) and recently finished quests.

signal navigate_requested(screen_name: String)

const DETAILS := "DimBackground/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/"

@onready var quest_list: VBoxContainer = $DimBackground/ScreenMargin/MainLayout/QuestColumns/QuestListPanel/QuestList
@onready var list_heading: Label = $DimBackground/ScreenMargin/MainLayout/QuestColumns/QuestListPanel/QuestList/ListHeading
@onready var quest_title: Label = get_node(DETAILS + "QuestTitle")
@onready var quest_description: Label = get_node(DETAILS + "QuestDescription")
@onready var objective_label: Label = get_node(DETAILS + "ObjectiveLabel")
@onready var deadline_label: Label = get_node(DETAILS + "DeadlineLabel")
@onready var reward_label: Label = get_node(DETAILS + "RewardLabel")
@onready var status_label: Label = get_node(DETAILS + "StatusLabel")
@onready var action_button: Button = get_node(DETAILS + "ActionButton")
@onready var action_hint: Label = get_node(DETAILS + "ActionHint")
@onready var back_button: Button = $DimBackground/ScreenMargin/MainLayout/BackButton

## How many finished quests to keep listed under "Recent".
const RECENT_LIMIT: int = 5

var selected_quest_id: String = ""


func _ready() -> void:
	# Lets this scene run on its own (F6) for testing.
	if get_tree().current_scene == self:
		GameState.start_preview_game_if_needed()

	back_button.pressed.connect(navigate_requested.emit.bind("colony"))
	action_button.pressed.connect(_on_action_pressed)
	GameState.state_changed.connect(refresh)
	refresh()


func refresh() -> void:
	_make_quest_buttons()
	var quest: Dictionary = _find_quest(selected_quest_id)
	if quest.is_empty() and not GameState.active_quests.is_empty():
		quest = GameState.active_quests[0]
	show_quest(quest)


func _make_quest_buttons() -> void:
	for child in quest_list.get_children():
		if child != list_heading:
			child.queue_free()

	for quest in GameState.active_quests:
		_add_quest_button(quest, quest.get("title", ""))

	var recent: Array = GameState.finished_quests.slice(-RECENT_LIMIT)
	if not recent.is_empty():
		var header := Label.new()
		header.text = "Recent"
		quest_list.add_child(header)
		recent.reverse()
		for quest in recent:
			_add_quest_button(quest, "%s (%s)" % [quest.get("title", ""), quest.get("status", "")])


func _add_quest_button(quest: Dictionary, text: String) -> void:
	var button := Button.new()
	button.text = text
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.pressed.connect(_on_quest_button_pressed.bind(quest))
	quest_list.add_child(button)


func _on_quest_button_pressed(quest: Dictionary) -> void:
	show_quest(quest)


func show_quest(quest: Dictionary) -> void:
	var has_quest: bool = not quest.is_empty()
	action_button.visible = false
	action_hint.text = ""
	if not has_quest:
		selected_quest_id = ""
		quest_title.text = "No active requests"
		quest_description.text = "New requests arrive from colonists each week."
		for label in [objective_label, deadline_label, reward_label, status_label]:
			label.text = ""
		return

	selected_quest_id = quest.get("id", "")
	quest_title.text = quest.get("title", "")
	quest_description.text = quest.get("description", "")
	objective_label.text = "Goal: " + quest.get("objective", "")
	reward_label.text = "Reward: " + quest.get("reward", "")
	status_label.text = "Status: " + str(quest.get("status", "active")).capitalize()

	var status: String = quest.get("status", "active")
	if status != "active":
		deadline_label.text = "Finished in week %s" % quest.get("finished_week", "?")
		return

	if quest.get("kind", "") == "quota":
		deadline_label.text = "Deadline: End of this week (you have %d Risium)" % GameState.get_resource("risium")
	else:
		var weeks_left: int = GameState.get_weeks_left(quest)
		deadline_label.text = "Deadline: %s" % ("End of this week" if weeks_left <= 0 else "In %d week(s)" % weeks_left)

	if quest.get("objective_type", "") == "build":
		deadline_label.text += "   Progress: %d/%d" % [int(quest.get("progress", 0)), int(quest.get("amount", 1))]

	var inputs: Dictionary = GameState.get_quest_inputs(quest)
	var reason: String = GameState.get_quest_complete_block_reason(quest)
	if not inputs.is_empty():
		action_button.visible = true
		action_button.text = "Hand over %s" % ContentDB.format_cost(inputs)
		action_button.disabled = reason != ""
	action_hint.text = reason


func _on_action_pressed() -> void:
	GameState.try_complete_quest(selected_quest_id)


func _find_quest(quest_id: String) -> Dictionary:
	if quest_id == "":
		return {}
	for quest in GameState.active_quests:
		if quest.get("id", "") == quest_id:
			return quest
	for quest in GameState.finished_quests:
		if quest.get("id", "") == quest_id:
			return quest
	return {}
