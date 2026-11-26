extends Control
## Lists every building in ContentDB.BUILDINGS with its cost and effects.
## Buttons are disabled (with the reason shown) when GameState says the
## building can't be placed. Choosing one emits building_chosen; ColonyScreen
## then asks GameState to place it.

signal building_chosen(building_id: String)
signal cancelled

const ColonyPanel = preload("res://colony_panel.gd")

@onready var title_label: Label = $PanelContainer/VBoxContainer/TitleLabel
@onready var building_list: VBoxContainer = $PanelContainer/VBoxContainer/Scroll/BuildingList
@onready var cancel_button: Button = $PanelContainer/VBoxContainer/CancelButton


func _ready() -> void:
	cancel_button.pressed.connect(_on_cancel_pressed)
	hide()


func open_for_tile(tile_position: Vector2i) -> void:
	title_label.text = "Build on tile %d, %d" % [tile_position.x, tile_position.y]
	_populate_buildings(tile_position)
	show()


func _populate_buildings(tile_position: Vector2i) -> void:
	for child in building_list.get_children():
		child.queue_free()

	var last_category: String = ""
	for definition in ContentDB.BUILDINGS:
		var category: String = str(definition.get("category", ""))
		if category != last_category:
			last_category = category
			var header := Label.new()
			header.text = category.capitalize()
			building_list.add_child(header)

		var reason: String = GameState.get_build_block_reason(definition["id"], tile_position)
		var button := Button.new()
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		var effects: String = ", ".join(ColonyPanel.describe_building(definition).slice(1))
		if definition.get("cost_tbd", false):
			button.text = "%s - cost TBD" % definition["name"]
		else:
			button.text = "%s - %s" % [definition["name"], ContentDB.format_cost(definition.get("cost", {}))]
		if effects != "":
			button.text += "\n   " + effects
		if reason != "":
			button.disabled = true
			button.tooltip_text = reason
			if not definition.get("cost_tbd", false):
				button.text += "\n   " + reason
		button.pressed.connect(_on_building_pressed.bind(definition["id"]))
		building_list.add_child(button)


func _on_building_pressed(building_id: String) -> void:
	hide()
	building_chosen.emit(building_id)


func _on_cancel_pressed() -> void:
	hide()
	cancelled.emit()
