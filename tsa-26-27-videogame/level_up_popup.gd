extends PanelContainer
@onready var level_label = $VBoxContainer/LevelLabel
@onready var bonus_label = $VBoxContainer/BonusLabel
@onready var continue_button = $VBoxContainer/ContinueButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	GameState.level_up.connect(show_level_up)
	continue_button.pressed.connect(on_continue_pressed)

func show_level_up(new_level: int, bonus_name: String, bonus_amount: float):
	level_label.text = "Level %d" % new_level
	bonus_label.text = "%s: +%s%%" % [bonus_name, bonus_amount]
	show()

func on_continue_pressed():
	hide()
