extends Control

signal tile_selected(position: Vector2i)


const TILE_SCENE = preload("res://ColonyTile.tscn")
@onready var grid: GridContainer = $Grid
var cols := 5
var rows := 4
var selected_tile = null
var tiles: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for y in rows:
		var row: Array = []
		for x in cols:
			var tile = TILE_SCENE.instantiate()
			tile.tile_position = Vector2i(x, y)
			#print(tile.tile_position)
			tile.selected.connect(_on_tile_selected)
			
			grid.add_child(tile)
			row.append(tile)
		tiles.append(row)

func _on_tile_selected(tile_position: Vector2i) -> void:
	if selected_tile != null:
		selected_tile.set_selected(false)
	
	selected_tile = tiles[tile_position.y][tile_position.x]
	selected_tile.set_selected(true)
	
	tile_selected.emit(tile_position)

func get_tile_at(position: Vector2i):
	return tiles[position.y][position.x]
