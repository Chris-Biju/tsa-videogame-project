extends Control
## Grid of ColonyTiles. The tiles only display data; which building sits on a
## tile is stored in GameState.buildings.

signal tile_selected(tile_position: Vector2i)

const TILE_SCENE = preload("res://ColonyTile.tscn")

@onready var grid: GridContainer = $Grid

var selected_tile = null
var tiles: Array = []


func _ready() -> void:
	grid.columns = ContentDB.MAP_COLUMNS
	for y in ContentDB.MAP_ROWS:
		var row: Array = []
		for x in ContentDB.MAP_COLUMNS:
			var tile = TILE_SCENE.instantiate()
			tile.tile_position = Vector2i(x, y)
			tile.selected.connect(_on_tile_selected)
			grid.add_child(tile)
			row.append(tile)
		tiles.append(row)
	refresh()


## Updates every tile from GameState.
func refresh() -> void:
	for row in tiles:
		for tile in row:
			tile.terrain_name = GameState.get_terrain(tile.tile_position)
			var instance: Dictionary = GameState.get_building_at(tile.tile_position)
			if instance.is_empty():
				tile.clear_building()
			else:
				var definition: Dictionary = ContentDB.get_building_by_id(instance["building_id"])
				tile.display_building(instance["building_id"], definition.get("name", ""), instance["status"])


func _on_tile_selected(tile_position: Vector2i) -> void:
	if selected_tile != null:
		selected_tile.set_selected(false)

	selected_tile = get_tile_at(tile_position)
	selected_tile.set_selected(true)

	tile_selected.emit(tile_position)


func get_tile_at(tile_position: Vector2i):
	return tiles[tile_position.y][tile_position.x]
