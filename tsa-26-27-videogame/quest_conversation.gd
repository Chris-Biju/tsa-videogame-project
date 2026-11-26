extends Control
## Plays a villager's dialogue from ContentDB, then offers their quest.
## GameRoot calls start_conversation() and forwards accept/decline to GameState.

signal quest_accepted(quest: Dictionary)
signal quest_declined(quest: Dictionary)

const CONTENT := "DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/"

@onready var speaker_name: Label = get_node(CONTENT + "SpeakerName")
@onready var dialogue_text: Label = get_node(CONTENT + "DialogueText")
@onready var portrait: TextureRect = get_node(CONTENT + "SpeakerRow/Portrait")

@onready var quest_summary: VBoxContainer = get_node(CONTENT + "QuestSummary")
@onready var quest_title: Label = get_node(CONTENT + "QuestSummary/QuestTitle")
@onready var objective_text: Label = get_node(CONTENT + "QuestSummary/ObjectiveText")
@onready var deadline_text: Label = get_node(CONTENT + "QuestSummary/DeadlineText")
@onready var reward_text: Label = get_node(CONTENT + "QuestSummary/RewardText")

@onready var continue_button: Button = get_node(CONTENT + "Buttons/ContinueButton")
@onready var accept_button: Button = get_node(CONTENT + "Buttons/AcceptButton")
@onready var decline_button: Button = get_node(CONTENT + "Buttons/DeclineButton")

var current_quest: Dictionary = {}
var dialogue_lines: Array = []
var line_index: int = 0


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	accept_button.pressed.connect(_on_accept_pressed)
	decline_button.pressed.connect(_on_decline_pressed)

	# Lets this scene run on its own (F6) for testing with a random quest.
	if get_tree().current_scene == self:
		start_conversation(ContentDB.get_random_villager_quest())
	else:
		hide()


func start_conversation(quest: Dictionary) -> void:
	current_quest = quest
	dialogue_lines = ContentDB.get_dialogue(str(quest.get("id", "")))
	line_index = 0

	var character: Dictionary = ContentDB.get_character_by_id(str(quest.get("character_id", "")))
	var portrait_path: String = str(character.get("portrait", ContentDB.DEFAULT_PORTRAIT))
	if ResourceLoader.exists(portrait_path):
		portrait.texture = load(portrait_path)

	quest_summary.hide()
	accept_button.hide()
	decline_button.hide()
	continue_button.show()

	if dialogue_lines.is_empty():
		_show_quest_offer()
	else:
		_show_current_line()

	show()


func _show_current_line() -> void:
	var line: Dictionary = dialogue_lines[line_index]
	speaker_name.text = line.get("speaker", "Unknown")
	dialogue_text.text = line.get("text", "")


func _on_continue_pressed() -> void:
	if line_index < dialogue_lines.size() - 1:
		line_index += 1
		_show_current_line()
	else:
		_show_quest_offer()


func _show_quest_offer() -> void:
	speaker_name.text = "Quest Request"
	dialogue_text.text = current_quest.get("description", "")

	quest_title.text = current_quest.get("title", "New Request")
	objective_text.text = "Goal: " + current_quest.get("objective", "")
	deadline_text.text = "Deadline: In %s week(s)" % str(current_quest.get("deadline_weeks", 0))
	reward_text.text = "Reward: " + current_quest.get("reward", "")

	continue_button.hide()
	quest_summary.show()
	accept_button.show()
	decline_button.show()


func _on_accept_pressed() -> void:
	hide()
	quest_accepted.emit(current_quest)


func _on_decline_pressed() -> void:
	hide()
	quest_declined.emit(current_quest)
