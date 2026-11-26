extends Control
@onready var colony_map = $VBoxContainer/MainContent/ColonyMap
@onready var colony_panel = $VBoxContainer/MainContent/ColonyPanel
@onready var build_menu = $BuildMenu
var selected_position := Vector2i.ZERO
const BUILDING_SCENE = preload("res://Building.tscn")

signal end_week_requested

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colony_panel.show_no_selection()
	colony_panel.build_requested.connect(_on_build_requested)
	build_menu.building_chosen.connect(_on_building_chosen)
	colony_map.tile_selected.connect(_on_colony_map_tile_selected)


func _on_colony_map_tile_selected(position: Vector2i) -> void:
	selected_position = position
	var tile = colony_map.get_tile_at(position)
	colony_panel.show_tile_details(position, tile.terrain_name, tile.building_name, tile.building_name == "")

func _on_build_requested() -> void:
	build_menu.show()

func _on_building_chosen(building_id: String) -> void:
	var tile = colony_map.get_tile_at(selected_position)
	var display_name: String = building_id.capitalize()
	
	if not tile.place_building(building_id, display_name):
		return
	var building = BUILDING_SCENE.instantiate()
	tile.add_child(building)
	building.setup(building_id, display_name)

	colony_panel.show_tile_details(selected_position, tile.terrain_name, tile.building_name, false)

func _on_colony_panel_build_requested() -> void:
	print("Build requested for tile: ", selected_position)


func _on_end_week_button_pressed() -> void:
	print("end")
	end_week_requested.emit()
