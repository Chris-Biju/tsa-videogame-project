extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func update_status(status: Dictionary) -> void:
	$WeekLabel.text = "Week: %s" % status.get("current_week", 1)
	$KristalsLabel.text = "Kristals: %s" % status.get("kristals", 0)
	$OxygenLabel.text = "Oxygen: %s" % status.get("oxygen", 0)
	$CarbonLabel.text = "Carbon: %s" % status.get("carbon", 0)
	$HydrogenLabel.text = "Hydrogen: %s" % status.get("hydrogen", 0)
	$CopperLabel.text = "Copper: %s" % status.get("copper", 0)
	$IronLabel.text = "Iron: %s" % status.get("iron", 0)
	$AluminumLabel.text = "Alumnium: %s" % status.get("aluminum", 0)
	$RisiumLabel.text = "Risium: %s" % status.get("risium", 0)
	$PopulationLabel.text = "Population: %s" % status.get("population", 0)
	$MoraleLabel.text = "Morale: %s" % status.get("morale", 0)
	
	var warning : String = status.get("warning", "")
	$WarningLabel.text = warning
	$WarningLabel.visible = warning != ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
