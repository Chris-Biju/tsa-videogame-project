extends Control

@onready var building_sprite: TextureRect = $BuildingSprite
@onready var name_label: Label = $NameLabel #ts is temp

var building_id: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func setup(id: String, display_name: String, texture: Texture2D = null) -> void:
	building_id = id
	name_label.text = display_name
	
	if texture != null:
		building_sprite.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
