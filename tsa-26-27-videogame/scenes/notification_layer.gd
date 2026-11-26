extends CanvasLayer
## Shows short messages from GameState.notify() one after another.

const SECONDS_PER_MESSAGE: float = 2.5

@onready var panel: PanelContainer = $Panel
@onready var message_label: Label = $Panel/MessageLabel
@onready var hide_timer: Timer = $HideTimer

var _queue: Array[String] = []


func _ready() -> void:
	panel.hide()
	hide_timer.wait_time = SECONDS_PER_MESSAGE
	hide_timer.one_shot = true
	hide_timer.timeout.connect(_show_next)


func show_notification(message: String) -> void:
	_queue.append(message)
	if hide_timer.is_stopped():
		_show_next()


func _show_next() -> void:
	if _queue.is_empty():
		panel.hide()
		return
	message_label.text = _queue.pop_front()
	panel.show()
	hide_timer.start()
