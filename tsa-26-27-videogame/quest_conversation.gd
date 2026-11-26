extends Control

signal quest_accepted(quest: Dictionary)
signal quest_declined(quest: Dictionary)

const QuestDatabase = preload("res://scripts/quest_database.gd")

@onready var speaker_name: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/SpeakerName
@onready var dialogue_text: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/DialogueText
@onready var portrait: TextureRect = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/SpeakerRow/Portrait

@onready var quest_summary: VBoxContainer = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/QuestSummary
@onready var quest_title: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/QuestSummary/QuestTitle
@onready var objective_text: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/QuestSummary/ObjectiveText
@onready var deadline_text: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/QuestSummary/DeadlineText
@onready var reward_text: Label = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/QuestSummary/RewardText

@onready var continue_button: Button = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/Buttons/ContinueButton
@onready var accept_button: Button = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/Buttons/AcceptButton
@onready var decline_button: Button = $DimBackground/CenterContainer/ConversationPanel/MarginContainer/Content/Buttons/DeclineButton

var current_quest: Dictionary = {}
var dialogue_lines: Array = []
var line_index: int = 0


func _ready() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	accept_button.pressed.connect(_on_accept_pressed)
	decline_button.pressed.connect(_on_decline_pressed)
	# Temporary preview: show the first quest from the database.
	var preview_quest: Dictionary = QuestDatabase.VILLAGER_QUESTS[randi_range(0, len(QuestDatabase.VILLAGER_QUESTS)-1)]
	start_conversation(preview_quest)
	


func start_conversation(quest: Dictionary) -> void:
	current_quest = quest
	dialogue_lines = QuestDatabase.get_dialogue(
		str(quest.get("id", ""))
	)
	line_index = 0

	quest_summary.hide()
	accept_button.hide()
	decline_button.hide()
	continue_button.show()

	if dialogue_lines.is_empty():
		speaker_name.text = "Dialogue missing"
		dialogue_text.text = "No conversation found for quest: " + str(quest.get("id", ""))
	else:
		_show_current_line()

	show()


func _show_current_line() -> void:
	var line: Dictionary = dialogue_lines[line_index]
	speaker_name.text = line.get("speaker", "Unknown")
	dialogue_text.text = line.get("text", "")
	var portrait_path: String = current_quest.get("portrait_path", "")


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
	quest_accepted.emit(current_quest)
	hide()


func _on_decline_pressed() -> void:
	quest_declined.emit(current_quest)
	hide()
