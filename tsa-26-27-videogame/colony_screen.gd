extends Control
@onready var colony_map = $VBoxContainer/MainContent/ColonyMap
@onready var colony_panel = $VBoxContainer/MainContent/ColonyPanel
var selected_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	colony_panel.show_no_selection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_colony_map_tile_selected(position: Vector2i) -> void:
	selected_position = position
	var tile = colony_map.get_tile_at(position)
	colony_panel.show_tile_details(position, tile.terrain_name, tile.building_name, tile.building_name == "")


func _on_colony_panel_build_requested() -> void:
	print("Build requested for tile: ", selected_position)
