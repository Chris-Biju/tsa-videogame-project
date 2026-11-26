extends Panel

#a signal to show whether the given tile is selected
signal selected(tile_position: Vector2i)


@export var terrain_texture: Texture2D
var tile_position : Vector2i = Vector2.ZERO
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
 
func is_buildable() -> bool:
	return not has_building

func place_building(id: String, display_name: String) -> bool:
	if not is_buildable():
		return false
	
	has_building = true
	building_name = display_name
	return true
