extends Control
## Leader selection. Card text comes from ContentDB.PLAYER_CLASSES; confirming
## emits character_confirmed and GameRoot starts the game in GameState.

signal character_confirmed(class_id: String)

const SELECTED_TINT := Color(1.0, 0.9, 0.4)

## Maps each class id to its card's content container in the scene.
@onready var cards: Dictionary = {
	"engineer": $maincontainer/cardscontainer/engineercard/engineercontent,
	"scientist": $maincontainer/cardscontainer/scientistcard/scientistcontent,
	"diplomat": $maincontainer/cardscontainer/diplomatcard/diplomatcontent,
	"commander": $maincontainer/cardscontainer/commandercard/VBoxContainer,
}
@onready var confirm_button: Button = $button

var selected_character: String = ""


func _ready() -> void:
	for class_id in cards:
		var content: Control = cards[class_id]
		var player_class: Dictionary = ContentDB.get_player_class(class_id)
		content.get_node("title").text = player_class.get("name", class_id.capitalize())
		_add_description(content, player_class)
		content.get_node("button").pressed.connect(select_character.bind(class_id))

	confirm_button.pressed.connect(confirm_selection)
	confirm_button.disabled = true


func _add_description(content: Control, player_class: Dictionary) -> void:
	var stats: Dictionary = player_class.get("starting_stats", {})
	var stat_lines: PackedStringArray = []
	for stat in stats:
		stat_lines.append("%s %d" % [str(stat).capitalize(), int(stats[stat])])
	var description := Label.new()
	description.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	description.custom_minimum_size = Vector2(180, 0)
	description.text = "%s\nBonus: %s\n%s" % [
		player_class.get("perk", ""),
		ContentDB.format_cost(player_class.get("starting_bonus", {})),
		"\n".join(stat_lines)
	]
	content.add_child(description)
	content.move_child(description, content.get_node("button").get_index())


func select_character(class_id: String) -> void:
	selected_character = class_id
	for id in cards:
		cards[id].get_parent().modulate = SELECTED_TINT if id == class_id else Color.WHITE
	confirm_button.disabled = false
	confirm_button.text = "CONFIRM: %s" % ContentDB.get_player_class(class_id).get("name", class_id)


func confirm_selection() -> void:
	if selected_character != "":
		character_confirmed.emit(selected_character)
