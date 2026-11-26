extends Control

var current_screen: Control

func show_screen(scene: PackedScene) -> void:
	if is_instance_valid(current_screen):
		current_screen.queue_free()
		
	current_screen = scene.instantiate() as Control
	add_child(current_screen)
	current_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
