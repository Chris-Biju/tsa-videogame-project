extends PanelContainer
## End-of-week summary. GameRoot calls show_report() with the dictionary
## returned by GameState.advance_week().

signal closed

@onready var week_label: Label = $VBoxContainer/WeekLabel
@onready var details_label: Label = $VBoxContainer/DetailsLabel
@onready var continue_button: Button = $VBoxContainer/ContinueButton


func _ready() -> void:
	hide()
	continue_button.pressed.connect(_on_continue_pressed)


func show_report(report: Dictionary) -> void:
	week_label.text = "Week %s summary" % report.get("week", "?")
	var lines: PackedStringArray = []
	for line in report.get("lines", []):
		lines.append("• " + str(line))
	details_label.text = "\n".join(lines)
	show()


func _on_continue_pressed() -> void:
	hide()
	closed.emit()
