extends CanvasLayer

@onready var panel: PanelContainer = $Panel
@onready var message_label: Label = $Panel/MessageLabel
@onready var hide_timer: Timer = $HideTimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	panel.hide()
	hide_timer.wait_time = 3.0
	hide_timer.one_shot = true
	hide_timer.timeout.connect(panel.hide)

	
func show_notification(message: String) -> void:
	message_label.text = message
	panel.show()
	hide_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
