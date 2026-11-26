extends Control



@onready var quest_list: VBoxContainer = $Background/ScreenMargin/MainLayout/QuestColumns/QuestListPanel/QuestList
@onready var quest_title: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/QuestTitle
@onready var quest_description: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/QuestDescription
@onready var objective_label: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/ObjectiveLabel
@onready var deadline_label: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/DeadlineLabel
@onready var reward_label: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/RewardLabel
@onready var status_label: Label = $Background/ScreenMargin/MainLayout/QuestColumns/QuestDetailsPanel/QuestDetails/StatusLabel

var active_quests: Array[Dictionary] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	## placeholder for weekly system
	start_week(1)

func start_week(week: int) -> void:
	active_quests.clear()
	## Company Quota
	active_quests.append(ContentDb.make_risium_quest(week))
	## Selecting villager requests from the database
	for i in 5:
		var possible_requests: Array = ContentDb.VILLAGER_QUESTS
		var random_index := randi_range(0, possible_requests.size()-1)
		var villager_quest: Dictionary = possible_requests[random_index].duplicate(true)
		villager_quest["appeared_week"] = week
		active_quests.append(villager_quest)
		make_quest_button()
		if not active_quests.is_empty():
			show_quest(active_quests[0])
	
func make_quest_button() -> void:
	for child in quest_list.get_children():
		child.queue_free()
	for quest in active_quests:
		var button := Button.new()
		button.text = quest["title"]
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		## expands quest details 
		button.pressed.connect(show_quest.bind(quest))
		
		quest_list.add_child(button)
func show_quest(quest: Dictionary) -> void:
	quest_title.text = quest["title"]
	quest_description.text = quest["description"]
	objective_label.text = "Goal: " + quest["objective"]
	var quest_id: String = str(quest.get("id", ""))
	if quest["id"].begins_with("risium_quota"):
		deadline_label.text = "Deadline: This week"
	else:
		var weeks_left: int = int(quest.get("deadline_weeks", 0))
		deadline_label.text = "Deadline: In %d week(s)" % weeks_left

	reward_label.text = "Reward: " + quest["reward"]
	status_label.text = "Status: " + quest["status"]
