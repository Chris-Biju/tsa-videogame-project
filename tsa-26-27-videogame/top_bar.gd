extends VBoxContainer
## Shows the key colony numbers. ColonyScreen calls update_status() with
## GameState.get_status() whenever GameState changes.

func update_status(status: Dictionary) -> void:
	$ProgressRow/ProgressBar.value = float(status.get("terraform_progress", 0.0))
	$HBoxContainer/WeekLabel.text = "Week: %s (%s left)" % [status.get("current_week", 1), status.get("remaining_weeks", 0)]
	$HBoxContainer/LevelLabel.text = "Level %s (%s/%s XP)" % [status.get("level", 1), status.get("xp", 0), status.get("xp_needed", 0)]
	$HBoxContainer/KristalsLabel.text = "Kristals: %s" % status.get("kristals", 0)
	$HBoxContainer/OxygenLabel.text = "Oxygen: %s" % status.get("oxygen", 0)
	$HBoxContainer/NitrogenLabel.text = "Nitrogen: %s" % status.get("nitrogen", 0)
	$HBoxContainer/CarbonLabel.text = "Carbon: %s" % status.get("carbon", 0)
	$HBoxContainer/HydrogenLabel.text = "Hydrogen: %s" % status.get("hydrogen", 0)
	$HBoxContainer/CopperLabel.text = "Copper: %s" % status.get("copper", 0)
	$HBoxContainer/IronLabel.text = "Iron: %s" % status.get("iron", 0)
	$HBoxContainer/AluminumLabel.text = "Aluminum: %s" % status.get("aluminum", 0)
	$HBoxContainer/RisiumLabel.text = "Risium: %s" % status.get("risium", 0)
	$HBoxContainer/PopulationLabel.text = "Population: %s (housing %s)" % [status.get("population", 0), status.get("housing", 0)]
	$HBoxContainer/MoraleLabel.text = "Morale: %s" % status.get("morale", 0)

	var warning: String = status.get("warning", "")
	$HBoxContainer/WarningLabel.text = warning
	$HBoxContainer/WarningLabel.visible = warning != ""
