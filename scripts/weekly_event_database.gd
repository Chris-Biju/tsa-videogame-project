extends RefCounted

const EVENTS: Array[Dictionary] = [
	{
		"id": "supply_disruption",
		"type": "SUPPLY PROBLEM",
		"title": "Supply Disruption",
		"description": "An Empire cargo ship has been delayed.",
		"effect": "No outside oxygen arrives this week."
	},
	{
		"id": "system_instability",
		"type": "SYSTEM FAILURE",
		"title": "Unstable Harvester",
		"description": "The Risium Harvester is shaking, and the workers have shut it down for safety.",
		"effect": "The Risium Harvester produces nothing this week."
	},
	{
		"id": "building_damage",
		"type": "COLONY DAMAGE",
		"title": "Dust Storm Damage",
		"description": "A dust storm has damaged one of the colony's buildings.",
		"effect": "One building must be repaired before it can produce resources again."
	},
	{
		"id": "resource_discovery",
		"type": "GOOD NEWS",
		"title": "New Resource Deposit",
		"description": "Surveyors found a useful deposit near the colony.",
		"effect": "The colony receives extra materials this week."
	}
]
