extends PanelContainer

signal build_requested

func show_tile_details(position: Vector2i, terrain: String, building: String, can_build: bool) -> void:
	$VBoxContainer/TitleLabel.text = "Tile %s, %s" % [position.x, position.y]
	$VBoxContainer/TerrainLabel.text = "Terrain: %s" % terrain
	
	var occupied := building != ""
	$VBoxContainer/BuildingLabel.visible = occupied
	$VBoxContainer/BuildingLabel.text = "Building: %s" % building
	
	$VBoxContainer/BuildButton.visible = can_build and not occupied

func show_no_selection() -> void:
	$VBoxContainer/TitleLabel.text = "Select a tile"
	$VBoxContainer/TerrainLabel.text = ""
	$VBoxContainer/BuildingLabel.visible = false
	$VBoxContainer/BuildButton.visible = false

func _on_build_button_pressed() -> void:
	build_requested.emit()
