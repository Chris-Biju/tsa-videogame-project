extends Control
## Colony home screen. Draws everything from GameState and sends the player's
## choices back to GameState as requests. GameRoot listens for the signals below.

signal end_week_requested
signal event_details_requested
signal navigate_requested(screen_name: String)

const NO_SELECTION := Vector2i(-1, -1)

@onready var top_bar = $VBoxContainer/TopBar
@onready var colony_map = $VBoxContainer/MainContent/ColonyMap
@onready var colony_panel = $VBoxContainer/MainContent/RightColumn/ColonyPanel
@onready var quests_button: Button = $VBoxContainer/MainContent/RightColumn/Actions/QuestsButton
@onready var research_button: Button = $VBoxContainer/MainContent/RightColumn/Actions/ResearchButton
@onready var end_week_button: Button = $VBoxContainer/MainContent/RightColumn/EndWeekButton
@onready var event_button: Button = $VBoxContainer/EventBanner/EventButton
@onready var build_menu = $BuildMenu

var selected_position: Vector2i = NO_SELECTION


func _ready() -> void:
	# Lets this scene run on its own (F6) for testing.
	if get_tree().current_scene == self:
		GameState.start_preview_game_if_needed()

	colony_map.tile_selected.connect(_on_colony_map_tile_selected)
	colony_panel.build_requested.connect(_on_build_requested)
	colony_panel.repair_requested.connect(_on_repair_requested)
	build_menu.building_chosen.connect(_on_building_chosen)
	quests_button.pressed.connect(navigate_requested.emit.bind("quests"))
	research_button.pressed.connect(navigate_requested.emit.bind("tech"))
	end_week_button.pressed.connect(end_week_requested.emit)
	event_button.pressed.connect(event_details_requested.emit)

	GameState.state_changed.connect(refresh)
	refresh()


## Redraws the whole screen from GameState.
func refresh() -> void:
	top_bar.update_status(GameState.get_status())
	colony_map.refresh()
	_refresh_panel()

	var event: Dictionary = GameState.current_event
	if event.is_empty():
		event_button.text = "No event this week."
		event_button.disabled = true
	else:
		event_button.text = "%s: %s  (click for details)" % [event.get("type", "EVENT"), event.get("title", "")]
		event_button.disabled = false

	end_week_button.disabled = GameState.get_week_block_reason() != ""


func _refresh_panel() -> void:
	if selected_position == NO_SELECTION:
		colony_panel.show_no_selection()
	else:
		colony_panel.show_tile(selected_position)


func _on_colony_map_tile_selected(tile_position: Vector2i) -> void:
	selected_position = tile_position
	_refresh_panel()


func _on_build_requested() -> void:
	if selected_position != NO_SELECTION:
		build_menu.open_for_tile(selected_position)


func _on_building_chosen(building_id: String) -> void:
	# GameState checks cost, unlocks and the tile, then emits state_changed.
	GameState.try_place_building(building_id, selected_position)


func _on_repair_requested() -> void:
	GameState.try_repair_building(selected_position)
