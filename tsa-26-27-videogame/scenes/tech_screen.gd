extends Control
## Research screen. Lists ContentDB.TECHNOLOGIES; researching is a request to
## GameState, which unlocks the buildings listed in the tech's "unlocks".

signal navigate_requested(screen_name: String)

const DETAILS := "Margin/Layout/Columns/DetailsPanel/Details/"

@onready var tech_list: VBoxContainer = $Margin/Layout/Columns/TechListPanel/TechList
@onready var name_label: Label = get_node(DETAILS + "NameLabel")
@onready var description_label: Label = get_node(DETAILS + "DescriptionLabel")
@onready var cost_label: Label = get_node(DETAILS + "CostLabel")
@onready var unlocks_label: Label = get_node(DETAILS + "UnlocksLabel")
@onready var research_button: Button = get_node(DETAILS + "ResearchButton")
@onready var hint_label: Label = get_node(DETAILS + "HintLabel")
@onready var back_button: Button = $Margin/Layout/BackButton

var selected_tech_id: String = ""


func _ready() -> void:
	# Lets this scene run on its own (F6) for testing.
	if get_tree().current_scene == self:
		GameState.start_preview_game_if_needed()

	back_button.pressed.connect(navigate_requested.emit.bind("colony"))
	research_button.pressed.connect(_on_research_pressed)
	GameState.state_changed.connect(refresh)
	refresh()


func refresh() -> void:
	for child in tech_list.get_children():
		child.queue_free()
	for tech in ContentDB.TECHNOLOGIES:
		var button := Button.new()
		var done: bool = tech["id"] in GameState.researched_techs
		button.text = tech.get("name", tech["id"]) + ("  (done)" if done else "")
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.pressed.connect(show_tech.bind(tech["id"]))
		tech_list.add_child(button)
	show_tech(selected_tech_id)


func show_tech(tech_id: String) -> void:
	selected_tech_id = tech_id
	var tech: Dictionary = ContentDB.get_technology_by_id(tech_id)
	research_button.visible = not tech.is_empty()
	if tech.is_empty():
		name_label.text = "Select a research topic to see details"
		for label in [description_label, cost_label, unlocks_label, hint_label]:
			label.text = ""
		return

	name_label.text = tech.get("name", tech_id)
	description_label.text = tech.get("description", "")
	if tech.get("cost_tbd", false):
		cost_label.text = "Cost: TBD"
	else:
		cost_label.text = "Cost: " + ContentDB.format_cost(tech.get("cost", {}))

	var unlock_names: PackedStringArray = []
	for building_id in tech.get("unlocks", []):
		unlock_names.append(ContentDB.get_building_by_id(building_id).get("name", building_id))
	unlocks_label.text = "Unlocks: " + ", ".join(unlock_names)

	var reason: String = GameState.get_research_block_reason(tech_id)
	research_button.disabled = reason != ""
	hint_label.text = reason


func _on_research_pressed() -> void:
	GameState.try_research(selected_tech_id)
