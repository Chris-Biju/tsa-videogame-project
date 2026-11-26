extends Node

signal state_changed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
# Week and remaining time
# Kristals
# Important resources such as oxygen, carbon, hydrogen, metals, and Risium
# Population and morale
var current_week: int = 0
var remaining_weeks: int = 52
var kristals: int = 5
var oxygen: int = 5
var carbon: int = 5
var hydrogen: int = 5
var risium: int = 5
var copper: int = 5
var iron: int = 5
var aluminum: int = 5
var morale: int = 100
var population: int = 1000
var selected_character = ""

func advance_week() -> Dictionary:
	current_week += 1
	kristals += 5
	oxygen -= 2
	
	var report: Dictionary = {
		"week": current_week,
		"kristals_gained": 5,
		"oxygen_used": 2
	}
	state_changed.emit()
	return report
