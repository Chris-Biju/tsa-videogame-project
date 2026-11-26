extends Control

var selected_character = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	$maincontainer/cardscontainer/engineercard/engineercontent/button.pressed.connect(on_engineer_pressed)
	$maincontainer/cardscontainer/scientistcard/scientistcontent/button.pressed.connect(on_scientist_pressed)
	$maincontainer/cardscontainer/diplomatcard/diplomatcontent/button.pressed.connect(on_diplomat_pressed)
	$maincontainer/cardscontainer/commandercard/VBoxContainer/button.pressed.connect(on_commander_pressed)
	$button.pressed.connect(on_confirm_selection)
	# Called every frame. 'delta' is the elapsed time since the previous frame.
func on_engineer_pressed():
	select_character("engineer")
func on_scientist_pressed():
	select_character("scientist")
func on_diplomat_pressed():
	select_character("diplomat")
func on_commander_pressed():
	select_character("commander")

func select_character(character):
	selected_character = character
func on_confirm_selection():
	if(selected_character != ""):
		GameState.selected_character = selected_character
		get_tree().change_scene_to_file("res://colony_screen.tscn")
