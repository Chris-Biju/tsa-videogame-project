extends Control

signal building_chosen(buiilding_id: String)
signal cancelled

@onready var building_list: VBoxContainer = $PanelContainer/VBoxContainer/BuildingList
@onready var cancel_button: Button = $PanelContainer/VBoxContainer/CancelButton

var building_options := [
	{"id": "habitat", "name": "Habitat"},
	{"id": "oxygen_pump", "name": "Oxygen Pump"},
	{"id" : "mine", "name": "Mine"}
	]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cancel_button.pressed.connect(_on_cancel_pressed)
	_populate_buildings()
	hide()

func _populate_buildings() -> void:
	for option in building_options:
		var button := Button.new()
		button.text = option["name"]
		button.pressed.connect(_on_building_pressed.bind(option["id"]))
		building_list.add_child(button)

func _on_building_pressed(building_id: String) -> void:
	building_chosen.emit(building_id)
	hide()

func _on_cancel_pressed():
	cancelled.emit()
	hide()
