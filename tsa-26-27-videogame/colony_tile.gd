extends Panel
## One clickable map cell. Purely visual: ColonyMap tells it what to show
## based on GameState, and it reports clicks with the selected signal.

signal selected(tile_position: Vector2i)

const BUILDING_SCENE = preload("res://Building.tscn")
const SELECTED_TINT := Color(1.0, 1.0, 0.55)

@export var terrain_texture: Texture2D

var tile_position: Vector2i = Vector2i.ZERO
var terrain_name: String = "Flat"
var building_id: String = ""
var building_name: String = ""
var building_status: String = ""

var _building_visual = null


func _ready() -> void:
	$TerrainSprite.texture = terrain_texture
	$BuildingSprite.visible = false
	$ConditionIcon.visible = false
	$SelectionBorder.visible = false


func set_selected(value: bool) -> void:
	$SelectionBorder.visible = value
	$TerrainSprite.modulate = SELECTED_TINT if value else Color.WHITE


func set_building(texture: Texture2D) -> void:
	$BuildingSprite.texture = texture
	$BuildingSprite.visible = texture != null


func has_building() -> bool:
	return building_id != ""


func display_building(id: String, display_name: String, status: String) -> void:
	if _building_visual == null or building_id != id:
		clear_building()
		_building_visual = BUILDING_SCENE.instantiate()
		add_child(_building_visual)
		_building_visual.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		_building_visual.setup(id, display_name)
	building_id = id
	building_name = display_name
	building_status = status
	_building_visual.set_status(status)
	$ConditionIcon.visible = status != GameState.STATUS_OPERATIONAL


func clear_building() -> void:
	if _building_visual != null:
		_building_visual.queue_free()
		_building_visual = null
	building_id = ""
	building_name = ""
	building_status = ""
	$ConditionIcon.visible = false


func _on_click_area_pressed() -> void:
	selected.emit(tile_position)
