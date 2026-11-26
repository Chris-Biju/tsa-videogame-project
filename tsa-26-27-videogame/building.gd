extends Control
## Visual for a placed building on a tile. Its data lives in GameState.buildings
## and its definition in ContentDB; this only displays it.

const DAMAGED_TINT := Color(1.0, 0.45, 0.45)
const UNSTABLE_TINT := Color(1.0, 0.8, 0.35)

@onready var building_sprite: TextureRect = $BuildingSprite
@onready var name_label: Label = $NameLabel # temporary until building art exists

var building_id: String = ""
var display_name: String = ""


func _ready() -> void:
	# Let clicks fall through to the tile's ClickArea underneath.
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	building_sprite.mouse_filter = Control.MOUSE_FILTER_IGNORE
	name_label.mouse_filter = Control.MOUSE_FILTER_IGNORE


func setup(id: String, new_display_name: String, texture: Texture2D = null) -> void:
	building_id = id
	display_name = new_display_name
	name_label.text = new_display_name
	if texture != null:
		building_sprite.texture = texture


func set_status(status: String) -> void:
	match status:
		GameState.STATUS_DAMAGED:
			modulate = DAMAGED_TINT
			name_label.text = "%s\n(damaged)" % display_name
		GameState.STATUS_UNSTABLE:
			modulate = UNSTABLE_TINT
			name_label.text = "%s\n(unstable)" % display_name
		_:
			modulate = Color.WHITE
			name_label.text = display_name
