extends Control
## GameRoot: the persistent interface. It connects the screens and popups to
## GameState and runs the order of things the player sees each week:
##
##   Character select -> Colony (first villager request)
##   End Week -> Resource report -> Weekly event -> New villager request -> Colony

@onready var screen_manager = $ScreenManager
@onready var notification_layer = $NotificationLayer
@onready var resource_report = $ModalLayer/ResourceReport
@onready var weekly_event_popup = $ModalLayer/WeeklyEvents
@onready var quest_conversation = $ModalLayer/QuestConversation

## True while the end-of-week popups are being shown one after another.
var _in_week_sequence: bool = false


func _ready() -> void:
	GameState.notification_requested.connect(notification_layer.show_notification)

	screen_manager.screen_shown.connect(_on_screen_shown)
	resource_report.closed.connect(_on_report_closed)
	weekly_event_popup.continue_pressed.connect(_on_event_closed)
	quest_conversation.quest_accepted.connect(GameState.accept_quest)
	quest_conversation.quest_declined.connect(GameState.decline_quest)

	screen_manager.show_screen("character_select")


func _on_screen_shown(screen_name: String, screen: Control) -> void:
	match screen_name:
		"character_select":
			screen.connect("character_confirmed", _on_character_confirmed)
		"colony":
			screen.connect("end_week_requested", _on_end_week_requested)
			screen.connect("event_details_requested", _on_event_details_requested)


func _on_character_confirmed(class_id: String) -> void:
	GameState.start_new_game(class_id)
	screen_manager.show_screen("colony")
	_offer_villager_quest()


func _on_end_week_requested() -> void:
	if _in_week_sequence:
		return # the report/event popups for the last week are still open
	var reason: String = GameState.get_week_block_reason()
	if reason != "":
		GameState.notify(reason)
		return
	_in_week_sequence = true
	var report: Dictionary = GameState.advance_week()
	resource_report.show_report(report)


func _on_report_closed() -> void:
	if not _in_week_sequence:
		return
	if GameState.is_game_over():
		_in_week_sequence = false
		GameState.notify("Week %d reached. The Empire will now judge your colony." % GameState.total_weeks)
		return
	if GameState.current_event.is_empty():
		_on_event_closed()
	else:
		weekly_event_popup.show_event(GameState.current_event)


func _on_event_closed() -> void:
	if not _in_week_sequence:
		return
	_in_week_sequence = false
	_offer_villager_quest()


## Opened from the colony screen's event banner, outside the week sequence.
func _on_event_details_requested() -> void:
	if not GameState.current_event.is_empty():
		weekly_event_popup.show_event(GameState.current_event)


func _offer_villager_quest() -> void:
	var quest: Dictionary = GameState.get_next_quest_offer()
	if not quest.is_empty():
		quest_conversation.start_conversation(quest)
