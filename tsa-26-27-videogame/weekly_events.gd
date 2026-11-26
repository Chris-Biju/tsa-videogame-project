extends Control
## Popup describing this week's event (GameState.current_event).
## GameRoot shows it after the week report and when the event banner is clicked.

signal continue_pressed

const CONTENT := "Background/CenterContainer/EventPanel/EventMargin/EventContent/"

@onready var event_type: Label = get_node(CONTENT + "EventType")
@onready var event_title: Label = get_node(CONTENT + "EventTitle")
@onready var event_description: Label = get_node(CONTENT + "EventDescription")
@onready var event_effect: Label = get_node(CONTENT + "EventEffect")
@onready var continue_button: Button = get_node(CONTENT + "ContinueButton")


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

	# Lets this scene run on its own (F6) for testing with a random event.
	if get_tree().current_scene == self:
		show_event(ContentDB.get_random_weekly_event())
	else:
		hide()


func show_event(event: Dictionary) -> void:
	event_type.text = event.get("type", "WEEKLY EVENT")
	event_title.text = event.get("title", "Unknown Event")
	event_description.text = event.get("description", "")
	# "result" is filled in by GameState once the event has been applied.
	event_effect.text = "Effect: " + str(event.get("result", event.get("effect_description", "No effect listed.")))
	show()


func _on_continue_button_pressed() -> void:
	hide()
	continue_pressed.emit()
