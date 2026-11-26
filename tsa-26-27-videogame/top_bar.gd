extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_status(status: Dictionary) -> void:
	$HBoxContainer/WeekLabel.text = "Week: %s" % status.get("current_week", 1)
	$HBoxContainer/KristalsLabel.text = "Kristals: %s" % status.get("kristals", 0)
	$HBoxContainer/OxygenLabel.text = "Oxygen: %s" % status.get("oxygen", 0)
	$HBoxContainer/CarbonLabel.text = "Carbon: %s" % status.get("carbon", 0)
	$HBoxContainer/HydrogenLabel.text = "Hydrogen: %s" % status.get("hydrogen", 0)
	$HBoxContainer/CopperLabel.text = "Copper: %s" % status.get("copper", 0)
	$HBoxContainer/IronLabel.text = "Iron: %s" % status.get("iron", 0)
	$HBoxContainer/AluminumLabel.text = "Alumnium: %s" % status.get("aluminum", 0)
	$HBoxContainer/RisiumLabel.text = "Risium: %s" % status.get("risium", 0)
	$HBoxContainer/PopulationLabel.text = "Population: %s" % status.get("population", 0)
	$HBoxContainer/MoraleLabel.text = "Morale: %s" % status.get("morale", 0)
	
	var warning : String = status.get("warning", "")
	$HBoxContainer/WarningLabel.text = warning
	$HBoxContainer/WarningLabel.visible = warning != ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
