extends PanelContainer
## Shows details for the selected tile, read from GameState and ContentDB.

signal build_requested
signal repair_requested

@onready var title_label: Label = $VBoxContainer/TitleLabel
@onready var terrain_label: Label = $VBoxContainer/TerrainLabel
@onready var building_label: Label = $VBoxContainer/BuildingLabel
@onready var details_label: Label = $VBoxContainer/DetailsLabel
@onready var build_button: Button = $VBoxContainer/BuildButton
@onready var repair_button: Button = $VBoxContainer/RepairButton


func show_tile(tile_position: Vector2i) -> void:
	title_label.text = "Tile %s, %s" % [tile_position.x, tile_position.y]
	terrain_label.text = "Terrain: %s" % GameState.get_terrain(tile_position)

	var instance: Dictionary = GameState.get_building_at(tile_position)
	var occupied: bool = not instance.is_empty()
	building_label.visible = occupied
	build_button.visible = not occupied
	repair_button.visible = false

	if not occupied:
		details_label.text = "Empty tile. Choose Build to see what you can place here."
		return

	var definition: Dictionary = ContentDB.get_building_by_id(instance["building_id"])
	building_label.text = "Building: %s" % definition.get("name", instance["building_id"])
	details_label.text = "\n".join(describe_building(definition, instance))

	if instance["status"] != GameState.STATUS_OPERATIONAL:
		var cost: Dictionary = GameState.get_repair_cost(instance)
		repair_button.visible = true
		repair_button.text = "Repair (%s)" % ContentDB.format_cost(cost)
		repair_button.disabled = not GameState.can_afford(cost)


func show_no_selection() -> void:
	title_label.text = "Select a tile"
	terrain_label.text = ""
	building_label.visible = false
	details_label.text = ""
	build_button.visible = false
	repair_button.visible = false


## Human-readable lines describing what a building does. Also used by BuildMenu.
static func describe_building(definition: Dictionary, instance: Dictionary = {}) -> PackedStringArray:
	var lines: PackedStringArray = []
	lines.append("Category: %s" % str(definition.get("category", "")).capitalize())
	if not instance.is_empty():
		lines.append("Status: %s" % str(instance.get("status", "")).capitalize())
	if definition.get("housing_capacity") != null:
		lines.append("Houses %d people" % int(definition["housing_capacity"]))
	if definition.get("output_per_week") != null:
		lines.append("+%d Kristals per week" % int(definition["output_per_week"]))
	if definition.get("resource_produced") != null and definition.get("production_per_week") != null:
		lines.append("+%d %s per week" % [int(definition["production_per_week"]), ContentDB.get_resource_name(definition["resource_produced"])])
	if definition.get("morale_change") != null:
		lines.append("+%d morale when built" % int(definition["morale_change"]))
	if definition.has("purpose"):
		lines.append(str(definition["purpose"]))
	return lines


func _on_build_button_pressed() -> void:
	build_requested.emit()


func _on_repair_button_pressed() -> void:
	repair_requested.emit()
