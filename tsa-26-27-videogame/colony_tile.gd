extends Panel

#a signal to show whether the given tile is selected
signal selected(tile_position: Vector2i)


@export var terrain_texture: Texture2D
var tile_position 
var has_building := false
var terrain_name := "Flat"
var building_name := ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TerrainSprite.texture = terrain_texture
	$BuildingSprite.visible = has_building
	$ConditionIcon.visible = false
	$SelectionBorder.visible = false

func set_selected(value: bool) -> void:
	$SelectionBorder.visible = value

func set_building(texture: Texture2D) -> void:
	$BuildingSprite.texture = texture
	$BuildingSprite.visible = texture != null

func _on_click_area_pressed() -> void:
	selected.emit(tile_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
