extends PanelContainer

@onready var week_label: Label = $VBoxContainer/WeekLabel
@onready var kristals_label: Label = $VBoxContainer/KristalsLabel
@onready var oxygen_label: Label = $VBoxContainer/OxygenLabel
@onready var continue_button: Button = $VBoxContainer/ContinueButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	continue_button.pressed.connect(_on_continue_pressed)
	
func show_report(report: Dictionary) -> void:
	week_label.text = "Week: %s" % report.get("week", "?")
	kristals_label.text = "Kristals gained: %s" % report.get("kristals_gained", 0)
	oxygen_label.text = "Oxygen used: %s" % report.get("oxygen_used", 0)
	show()
	
func _on_continue_pressed() -> void:
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
