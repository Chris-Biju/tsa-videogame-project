extends Control
signal continue_pressed


@onready var event_type: Label = $Background/CenterContainer/EventPanel/EventMargin/EventContent/EventType
@onready var event_title: Label = $Background/CenterContainer/EventPanel/EventMargin/EventContent/EventTitle
@onready var event_description: Label = $Background/CenterContainer/EventPanel/EventMargin/EventContent/EventDescription
@onready var event_effect: Label = $Background/CenterContainer/EventPanel/EventMargin/EventContent/EventEffect
@onready var continue_button: Button = $Background/CenterContainer/EventPanel/EventMargin/EventContent/ContinueButton

func _ready() -> void:
	continue_button.pressed.connect(_on_continue_button_pressed)

	# Temporary preview: choose a random event when testing this scene.
	var event: Dictionary = ContentDb.get_random_weekly_event()
	show_event(event)


func show_event(event: Dictionary) -> void:
	event_type.text = event.get("type", "WEEKLY EVENT")
	event_title.text = event.get("title", "Unknown Event")
	event_description.text = event.get("description", "")
	event_effect.text = "Effect: " + event.get("effect", "No effect listed.")


func _on_continue_button_pressed() -> void:
	continue_pressed.emit()
	hide()
