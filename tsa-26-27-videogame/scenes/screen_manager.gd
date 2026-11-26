extends Control
## Shows one full-screen view at a time. It only handles navigation; it does
## not own any game rules.
##
## Any screen can ask to switch views by declaring
##     signal navigate_requested(screen_name: String)
## and emitting it with one of the names in SCREENS.

signal screen_shown(screen_name: String, screen: Control)

const SCREENS: Dictionary = {
	"character_select": preload("res://character_select_screen.tscn"),
	"colony": preload("res://colony_screen.tscn"),
	"quests": preload("res://quest_screen.tscn"),
	"tech": preload("res://scenes/TechScreen.tscn"),
}

var current_screen: Control
var current_screen_name: String = ""


func show_screen(screen_name: String) -> void:
	if not SCREENS.has(screen_name):
		push_error("ScreenManager: unknown screen '%s'" % screen_name)
		return

	if is_instance_valid(current_screen):
		current_screen.queue_free()

	current_screen = SCREENS[screen_name].instantiate() as Control
	current_screen_name = screen_name
	add_child(current_screen)
	current_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

	if current_screen.has_signal("navigate_requested"):
		current_screen.connect("navigate_requested", show_screen)

	screen_shown.emit(screen_name, current_screen)
