extends Node
## Content catalog: definitions shared across the game.
## Changing playthrough state, like active quests and resource totals,
## belongs in GameState, not here.

const DEFAULT_PORTRAIT := "res://icon.svg"

const RESOURCES: Dictionary = {
	"kristals": {
		"name": "Kristals",
		"category": "currency"
	},
	"oxygen": {
		"name": "Oxygen",
		"category": "gas"
	},
	"nitrogen": {
		"name": "Nitrogen",
		"category": "gas"
	},
	"hydrogen": {
		"name": "Hydrogen",
		"category": "gas"
	},
	"iron": {
		"name": "Iron",
		"category": "metal"
	},
	"copper": {
		"name": "Copper",
		"category": "metal"
	},
	"aluminum": {
		"name": "Aluminum",
		"category": "metal"
	},
	"risium": {
		"name": "Risium",
		"category": "metal"
	},
	"carbon": {
		"name": "Carbon",
		"category": "nonmetal"
	}
}


## Character definitions. The default Godot icon is a temporary portrait.
const CHARACTERS: Array[Dictionary] = [
	{"id": "player", "name": "Colony Leader", "role": "Player character", "portrait": DEFAULT_PORTRAIT},
	{"id": "mining_worker", "name": "Mining Shift Worker", "role": "Miner", "portrait": DEFAULT_PORTRAIT},
	{"id": "shop_owner", "name": "Shop Owner", "role": "Small business owner", "portrait": DEFAULT_PORTRAIT},
	{"id": "dockworker", "name": "Dockworker", "role": "Cargo handler", "portrait": DEFAULT_PORTRAIT},
	{"id": "botanist", "name": "Retired Botanist", "role": "Scientist", "portrait": DEFAULT_PORTRAIT},
	{"id": "settlement_leader", "name": "Settlement Leader", "role": "Outskirts representative", "portrait": DEFAULT_PORTRAIT},
	{"id": "weather_officer", "name": "Weather Officer", "role": "Colony meteorologist", "portrait": DEFAULT_PORTRAIT},
	{"id": "mine_foreman", "name": "Mine Foreman", "role": "Mining supervisor", "portrait": DEFAULT_PORTRAIT},
	{"id": "safety_engineer", "name": "Safety Engineer", "role": "Colony engineer", "portrait": DEFAULT_PORTRAIT},
	{"id": "concerned_resident", "name": "Concerned Resident", "role": "Colony resident", "portrait": DEFAULT_PORTRAIT},
	{"id": "surveyor", "name": "Surveyor", "role": "Resource surveyor", "portrait": DEFAULT_PORTRAIT},
	{"id": "blackstone_rep", "name": "Blackstone Representative", "role": "Corporate representative", "portrait": DEFAULT_PORTRAIT},
	{"id": "smuggler", "name": "Smuggler", "role": "Informal oxygen trader", "portrait": DEFAULT_PORTRAIT},
	{"id": "pilot", "name": "Pilot", "role": "Expedition pilot", "portrait": DEFAULT_PORTRAIT},
	{"id": "banker", "name": "Banker", "role": "Colony lender", "portrait": DEFAULT_PORTRAIT},
	{"id": "shift_supervisor", "name": "Shift Supervisor", "role": "Worker representative", "portrait": DEFAULT_PORTRAIT},
	{"id": "baker", "name": "Baker", "role": "Shop owner", "portrait": DEFAULT_PORTRAIT},
	{"id": "resident", "name": "Resident", "role": "Colony resident", "portrait": DEFAULT_PORTRAIT},
	{"id": "miner_rep", "name": "Miner Representative", "role": "Mining workforce representative", "portrait": DEFAULT_PORTRAIT},
	{"id": "empire_rep", "name": "Empire Representative", "role": "Galaktik Empire representative", "portrait": DEFAULT_PORTRAIT}
]


## Building definitions. A cost or production value marked TBD was not provided yet.
const BUILDINGS: Array[Dictionary] = [
	{
		"id": "small_home",
		"name": "Small Home",
		"category": "housing",
		"cost": {"kristals": 5, "carbon": 3, "oxygen": 2},
		"housing_capacity": 4
	},
	{
		"id": "medium_home",
		"name": "Medium Home",
		"category": "housing",
		"cost": {"kristals": 10, "carbon": 7, "oxygen": 5, "aluminum": 1},
		"housing_capacity": 10
	},
	{
		"id": "apartment_complex",
		"name": "Apartment Complex",
		"category": "housing",
		"cost": {"kristals": 20, "carbon": 15, "oxygen": 10, "aluminum": 8, "copper": 5},
		"housing_capacity": 25
	},
	{
		"id": "large_apartment_complex",
		"name": "Large Apartment Complex",
		"category": "housing",
		"cost": {"kristals": 40, "carbon": 30, "oxygen": 25, "aluminum": 20, "copper": 15, "iron": 10},
		"housing_capacity": 75
	},
	{
		"id": "skyscraper",
		"name": "Skyscraper",
		"category": "housing",
		"owner": "Blackstone",
		"cost": {"kristals": 80, "carbon": 75, "aluminum": 80, "oxygen": 40, "copper": 30, "iron": 25},
		"housing_capacity": 200,
		"output_per_week": 100,
		"notes": "Blackstone-owned housing. Rent and settlement morale consequences are handled by game rules."
	},

	{
		"id": "small_shop",
		"name": "Small Shop",
		"example_business": "Biju's Little Curry Shop",
		"category": "commerce",
		"cost": {"kristals": 5, "carbon": 3, "hydrogen": 3},
		"output_per_week": 5,
		"morale_change": 5
	},
	{
		"id": "medium_shop",
		"name": "Medium Shop",
		"example_business": "The Cinnabuns",
		"category": "commerce",
		"cost": {"kristals": 15, "carbon": 7, "hydrogen": 5, "aluminum": 3},
		"output_per_week": 15,
		"morale_change": 10
	},
	{
		"id": "large_shop",
		"name": "Large Shop",
		"example_business": "New York Sub Hub",
		"category": "commerce",
		"cost": {"kristals": 30, "carbon": 15, "hydrogen": 10, "aluminum": 10, "copper": 5},
		"output_per_week": 50,
		"morale_change": 15
	},
	{
		"id": "supermerkado",
		"name": "Supermerkado",
		"category": "commerce",
		"cost": {"kristals": 50, "carbon": 35, "hydrogen": 25, "aluminum": 25, "copper": 20, "iron": 15},
		"output_per_week": 150,
		"morale_change": 20
	},

	{
		"id": "resource_storage",
		"name": "Resource Storage",
		"category": "infrastructure",
		"cost": {},
		"cost_tbd": true,
		"storage_capacity": null
	},
	{
		"id": "factory",
		"name": "Factory",
		"category": "industry",
		"purpose": "Produces terraforming materials.",
		"cost": {},
		"cost_tbd": true,
		"production": "TBD"
	},
	{
		"id": "bank",
		"name": "Bank",
		"category": "finance",
		"purpose": "Increases economic output and offers loans.",
		"cost": {},
		"cost_tbd": true,
		"output_per_week": null
	},
	{
		"id": "park",
		"name": "Park",
		"category": "morale",
		"cost": {},
		"cost_tbd": true,
		"morale_change": null
	},
	{
		"id": "garden",
		"name": "Garden",
		"category": "food_and_morale",
		"cost": {},
		"cost_tbd": true,
		"production": "TBD"
	},
	{
		"id": "spaceport",
		"name": "Spaceport",
		"category": "expedition",
		"purpose": "Enables expeditions for rare materials.",
		"cost": {},
		"cost_tbd": true
	},

	{
		"id": "oxygen_harvester",
		"name": "Oxygen Harvester",
		"category": "resource_gathering",
		"resource_produced": "oxygen",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "nitrogen_harvester",
		"name": "Nitrogen Harvester",
		"category": "resource_gathering",
		"resource_produced": "nitrogen",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "hydrogen_harvester",
		"name": "Hydrogen Harvester",
		"category": "resource_gathering",
		"resource_produced": "hydrogen",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "iron_harvester",
		"name": "Iron Harvester",
		"category": "resource_gathering",
		"resource_produced": "iron",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "copper_harvester",
		"name": "Copper Harvester",
		"category": "resource_gathering",
		"resource_produced": "copper",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "aluminum_harvester",
		"name": "Aluminum Harvester",
		"category": "resource_gathering",
		"resource_produced": "aluminum",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "risium_harvester",
		"name": "Risium Harvester",
		"category": "resource_gathering",
		"resource_produced": "risium",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},
	{
		"id": "carbon_harvester",
		"name": "Carbon Harvester",
		"category": "resource_gathering",
		"resource_produced": "carbon",
		"cost": {},
		"cost_tbd": true,
		"production_per_week": null
	},

	{"id": "small_oxygen_pump", "name": "Small Oxygen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{"id": "medium_oxygen_pump", "name": "Medium Oxygen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{"id": "large_oxygen_pump", "name": "Large Oxygen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{"id": "small_nitrogen_pump", "name": "Small Nitrogen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{"id": "medium_nitrogen_pump", "name": "Medium Nitrogen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{"id": "large_nitrogen_pump", "name": "Large Nitrogen Pump", "category": "terraforming", "cost": {}, "cost_tbd": true, "atmosphere_output": null},
	{
		"id": "co2_factory",
		"name": "CO2 Factory",
		"category": "terraforming",
		"cost": {},
		"cost_tbd": true,
		"inputs": {"carbon": null, "oxygen": null},
		"output": {"co2": null}
	}
]


## Terraform actions. Costs were not specified, so fill these values in later.
const TERRAFORM_ACTIONS: Array[Dictionary] = [
	{
		"id": "place_water_tile",
		"name": "Add Water Tile",
		"cost": {},
		"cost_tbd": true,
		"inputs": ["oxygen", "hydrogen"]
	},
	{
		"id": "place_biomass_tile",
		"name": "Add Biomass Tile",
		"cost": {},
		"cost_tbd": true,
		"inputs": ["carbon", "oxygen", "hydrogen", "nitrogen"]
	},
	{
		"id": "increase_temperature",
		"name": "Increase Temperature",
		"cost": {},
		"cost_tbd": true,
		"temperature_change_per_week": null
	}
]


## Villager and corporate quest templates. Runtime status is tracked outside this catalog.
const VILLAGER_QUESTS: Array[Dictionary] = [
	{"id": "build_shop", "character_id": "mining_worker", "title": "A Place to Rest", "description": "A worker asks for a small shop near the mining area.", "objective": "Build 1 Small Shop", "deadline_weeks": 3, "reward": "5 Kristals and +5 morale", "objective_type": "build", "target": "small_shop", "amount": 1, "reward_effects": {"kristals": 5, "morale": 5}},
	{"id": "hungry_stoves", "character_id": "shop_owner", "title": "Cold Stoves", "description": "A shop owner is running out of hydrogen and can't keep the stoves lit.", "objective": "Deliver 5 Hydrogen to the Small Shop", "deadline_weeks": 2, "reward": "Shop output +5 and +5 morale", "objective_type": "deliver", "target": "hydrogen", "amount": 5, "reward_effects": {"morale": 5}},
	{"id": "missing_copper", "character_id": "dockworker", "title": "The Missing Shipment", "description": "A dockworker swears a copper shipment never reached storage. Everyone's story is slightly different.", "objective": "Talk to 3 citizens and name the culprit", "deadline_weeks": 3, "reward": "10 Copper and a new ally", "objective_type": "investigate", "target": "missing_copper", "reward_effects": {"copper": 10}},
	{"id": "garden_dreams", "character_id": "botanist", "title": "Garden Dreams", "description": "A retired botanist wants a place where something green can grow.", "objective": "Build 1 Garden", "deadline_weeks": 5, "reward": "+10 morale and a discount on biomass tiles", "objective_type": "build", "target": "garden", "amount": 1, "reward_effects": {"morale": 10}},
	{"id": "breathing_tax", "character_id": "settlement_leader", "title": "The Breathing Tax", "description": "Squatters on the outskirts are drowning in oxygen costs, and their leader asks for help.", "objective": "Build 1 Small Oxygen Pump in the outskirts", "deadline_weeks": 4, "reward": "+20 morale and settlement loyalty", "objective_type": "build", "target": "small_oxygen_pump", "location": "outskirts", "amount": 1, "reward_effects": {"morale": 20}},
	{"id": "dust_storm_prep", "character_id": "weather_officer", "title": "Storm on the Horizon", "description": "The weather officer warns a dust storm will hit soon and the harvesters are exposed.", "objective": "Stockpile 15 Oxygen and reinforce 3 buildings", "deadline_weeks": 2, "reward": "No storm damage", "objective_type": "compound"},
	{"id": "mine_collapse", "character_id": "mine_foreman", "title": "Trapped Below", "description": "A tunnel has collapsed with miners still inside, and the foreman is begging for rescue gear.", "objective": "Spend 5 Aluminum and 3 Copper on rescue equipment", "deadline_weeks": 1, "reward": "Miners saved, +10 morale, and workforce loyalty", "objective_type": "spend_resources", "inputs": {"aluminum": 5, "copper": 3}, "reward_effects": {"morale": 10}},
	{"id": "oxygen_leak", "character_id": "safety_engineer", "title": "Something's Hissing", "description": "The safety engineer detects an oxygen leak but can't tell which of three buildings it's coming from.", "objective": "Question the engineer and 2 residents, then seal the correct building", "deadline_weeks": 2, "reward": "Oxygen loss stopped and 5 Kristals", "objective_type": "investigate_and_repair", "reward_effects": {"kristals": 5}},
	{"id": "rebellion_brewing", "character_id": "concerned_resident", "title": "Whispers in the Dark", "description": "A rebel sympathizer warns that a protest is being planned and morale is low.", "objective": "Raise morale above 60 or negotiate with the protest leaders", "deadline_weeks": 3, "reward": "Protest cancelled and +15 morale", "objective_type": "choice", "reward_effects": {"morale": 15}},
	{"id": "new_deposit", "character_id": "surveyor", "title": "Strike It Rich", "description": "Surveyors found a Risium deposit, but a rival mining crew is already eyeing it.", "objective": "Build 1 Risium Harvester at the deposit", "deadline_weeks": 2, "reward": "+5 Risium per week", "objective_type": "build", "target": "risium_harvester", "amount": 1},
	{"id": "landlord_offer", "character_id": "blackstone_rep", "title": "The Landlord's Offer", "description": "Blackstone will fund a Skyscraper if you let them raise rents. The settlements won't like it.", "objective": "Build 1 Skyscraper", "deadline_weeks": 6, "reward": "50 Kristals and +100 output, but -20 morale in the settlements", "objective_type": "choice_and_build", "target": "skyscraper", "amount": 1, "reward_effects": {"kristals": 50, "morale": -20}},
	{"id": "underground_trade", "character_id": "smuggler", "title": "No Questions Asked", "description": "A smuggler offers cheap oxygen cylinders to the squatters. It's illegal, but it works.", "objective": "Decide to allow, shut down, or tax the smuggling operation", "deadline_weeks": 2, "reward": "Depends on your choice: +10 morale, +10 citizen trust, or 20 Kristals", "objective_type": "choice"},
	{"id": "spaceport_gamble", "character_id": "pilot", "title": "Into the Void", "description": "A pilot proposes an expedition for rare materials. It could pay off big or lose everything.", "objective": "Fund 1 Spaceport expedition with 10 Aluminum and 10 Hydrogen", "deadline_weeks": 4, "reward": "1 rare tech component", "objective_type": "expedition", "target": "spaceport", "inputs": {"aluminum": 10, "hydrogen": 10}},
	{"id": "bank_loan", "character_id": "banker", "title": "Borrowed Time", "description": "The banker offers fast cash at a high interest rate, due in 8 weeks.", "objective": "Accept the loan and repay it in full", "deadline_weeks": 8, "reward": "40 Kristals upfront to build faster", "objective_type": "loan"},
	{"id": "shift_burnout", "character_id": "shift_supervisor", "title": "Running on Empty", "description": "The shift supervisor says the workers are exhausted and a strike is likely.", "objective": "Build 1 Medium Shop or choose shorter shifts", "deadline_weeks": 3, "reward": "+15 morale and +10 output for 4 weeks", "objective_type": "choice", "reward_effects": {"morale": 15}},
	{"id": "bigger_kitchen", "character_id": "baker", "title": "A Bigger Kitchen", "description": "A baker wants to expand into a larger shop but can't afford the aluminum.", "objective": "Choose to give a loan, build it yourself as a partner, or decline", "deadline_weeks": 4, "reward": "Loan: interest income. Partnership: you build the shop and take 20% of its output. Decline: nothing.", "objective_type": "choice"},
	{"id": "water_rations", "character_id": "resident", "title": "Dry Taps", "description": "Residents report that the water supply is running thin and tempers are rising.", "objective": "Place 2 water tiles using Oxygen and Hydrogen", "deadline_weeks": 3, "reward": "+10 morale and 5 Kristals from grateful shopkeepers", "objective_type": "terraform", "target": "place_water_tile", "amount": 2, "reward_effects": {"morale": 10, "kristals": 5}},
	{"id": "miners_union", "character_id": "miner_rep", "title": "Safety First", "description": "The miners want a union and better safety gear after too many close calls.", "objective": "Recognize the union or spend 10 Iron and 5 Aluminum on gear upgrades", "deadline_weeks": 4, "reward": "+15 morale and fewer accidents for 6 weeks", "objective_type": "choice", "reward_effects": {"morale": 15}},
	{"id": "festival_day", "character_id": "shop_owner", "title": "A Reason to Celebrate", "description": "Shop owners want to throw a colony-wide festival to lift everyone's spirits.", "objective": "Spend 10 Kristals and 5 Hydrogen on a festival", "deadline_weeks": 2, "reward": "+20 morale for 3 weeks", "objective_type": "spend_resources", "inputs": {"kristals": 10, "hydrogen": 5}, "reward_effects": {"morale": 20}}
]


## Dialogue is keyed by quest ID. Each line is one speaker turn.
const QUEST_DIALOGUE: Dictionary = {
	"build_shop": [
		{"speaker": "Mining Shift Worker", "text": "Leader, do you have a minute? The crew has been talking after our shifts."},
		{"speaker": "You", "text": "What's going on?"},
		{"speaker": "Mining Shift Worker", "text": "We work long hours, but there's nowhere near the mine to eat or rest."},
		{"speaker": "You", "text": "What do you think would help?"},
		{"speaker": "Mining Shift Worker", "text": "A small shop nearby would give everyone a place to catch their breath."}
	],
	"hungry_stoves": [
		{"speaker": "Shop Owner", "text": "I'm sorry to bother you, but my stoves are going cold."},
		{"speaker": "You", "text": "What's wrong with them?"},
		{"speaker": "Shop Owner", "text": "They run on hydrogen. My supply is nearly gone, and I can't cook without it."},
		{"speaker": "You", "text": "How much do you need to keep the shop going?"},
		{"speaker": "Shop Owner", "text": "Five units should get the stoves running again. The whole street is counting on this place."}
	],
	"missing_copper": [
		{"speaker": "Dockworker", "text": "A copper shipment went missing between the landing pad and storage."},
		{"speaker": "You", "text": "Could it have been misplaced?"},
		{"speaker": "Dockworker", "text": "Maybe. But three people gave me three different stories about where it went."},
		{"speaker": "You", "text": "Who should I speak to?"},
		{"speaker": "Dockworker", "text": "Talk to the people who handled the shipment. Someone knows more than they're saying."}
	],
	"garden_dreams": [
		{"speaker": "Retired Botanist", "text": "I know this place is young, but I still dream about seeing something green here."},
		{"speaker": "You", "text": "You think a garden could grow on this moon?"},
		{"speaker": "Retired Botanist", "text": "With the right conditions, yes. It would take work, but the soil can be prepared."},
		{"speaker": "You", "text": "Why does a garden matter so much to you?"},
		{"speaker": "Retired Botanist", "text": "People need more than shelter and oxygen. They need a reason to believe this place can become a home."}
	],
	"breathing_tax": [
		{"speaker": "Settlement Leader", "text": "The families on the outskirts are paying more for oxygen than they can afford."},
		{"speaker": "You", "text": "Why can't they use the colony's oxygen supply?"},
		{"speaker": "Settlement Leader", "text": "The pump doesn't reach us. We buy cylinders from whoever is willing to sell."},
		{"speaker": "You", "text": "What would make the biggest difference?"},
		{"speaker": "Settlement Leader", "text": "Build a small oxygen pump out there. Let people breathe without choosing between air and food."}
	],
	"dust_storm_prep": [
		{"speaker": "Weather Officer", "text": "I've been tracking a storm moving toward the colony."},
		{"speaker": "You", "text": "How long do we have?"},
		{"speaker": "Weather Officer", "text": "Not long. The exposed harvesters and outer buildings are at risk."},
		{"speaker": "You", "text": "What should we do before it hits?"},
		{"speaker": "Weather Officer", "text": "Build up oxygen reserves and reinforce three buildings. We won't get a second chance once the storm arrives."}
	],
	"mine_collapse": [
		{"speaker": "Mine Foreman", "text": "A tunnel collapsed. There are still miners trapped below."},
		{"speaker": "You", "text": "Are they alive?"},
		{"speaker": "Mine Foreman", "text": "We heard tapping through the rubble. They're alive, but the tunnel could shift again."},
		{"speaker": "You", "text": "What do you need to reach them?"},
		{"speaker": "Mine Foreman", "text": "Aluminum supports and copper wiring for the rescue gear. Please, we can't leave them down there."}
	],
	"oxygen_leak": [
		{"speaker": "Safety Engineer", "text": "We're losing oxygen somewhere in the colony."},
		{"speaker": "You", "text": "Do you know where the leak is?"},
		{"speaker": "Safety Engineer", "text": "Not yet. Three buildings have similar pressure readings, and the instruments aren't precise enough."},
		{"speaker": "You", "text": "Who can help narrow it down?"},
		{"speaker": "Safety Engineer", "text": "Question me and the residents nearby. Someone may have noticed the first signs. Then we can seal the right building."}
	],
	"rebellion_brewing": [
		{"speaker": "Concerned Resident", "text": "People are talking about a protest. Some are saying they'll shut down the central plaza."},
		{"speaker": "You", "text": "What are they angry about?"},
		{"speaker": "Concerned Resident", "text": "They feel ignored. Morale has been falling, and the settlement leaders think the company only listens to quotas."},
		{"speaker": "You", "text": "Can this still be resolved peacefully?"},
		{"speaker": "Concerned Resident", "text": "Talk to the protest leaders. If you address what they're asking for, they may listen."}
	],
	"new_deposit": [
		{"speaker": "Surveyor", "text": "We found a rich Risium deposit beyond the eastern ridge."},
		{"speaker": "You", "text": "That sounds like good news. Why do you look worried?"},
		{"speaker": "Surveyor", "text": "A rival mining crew spotted it too. They'll claim the site if we don't move quickly."},
		{"speaker": "You", "text": "What would it take to secure the deposit?"},
		{"speaker": "Surveyor", "text": "Build a Risium Harvester there before they do. The deposit could support the colony for a long time."}
	],
	"landlord_offer": [
		{"speaker": "Blackstone Representative", "text": "Blackstone is prepared to fund a new Skyscraper for the colony."},
		{"speaker": "You", "text": "What's the catch?"},
		{"speaker": "Blackstone Representative", "text": "We would manage the building and adjust the rents to reflect its value."},
		{"speaker": "You", "text": "The settlements won't accept a rent increase easily."},
		{"speaker": "Blackstone Representative", "text": "That is a political concern. The funding offer is available if you approve the construction."}
	],
	"underground_trade": [
		{"speaker": "Smuggler", "text": "You didn't hear this from me, but I can get oxygen cylinders to the outskirts for less."},
		{"speaker": "You", "text": "You're smuggling oxygen?"},
		{"speaker": "Smuggler", "text": "I'm getting people air. The official sellers charge more than many families can pay."},
		{"speaker": "You", "text": "This could help people, but it could also cause trouble."},
		{"speaker": "Smuggler", "text": "Then decide what matters more: stopping me, taxing the trade, or letting it continue."}
	],
	"spaceport_gamble": [
		{"speaker": "Pilot", "text": "I've got a route to an uncharted moon with rare materials."},
		{"speaker": "You", "text": "What makes the trip a gamble?"},
		{"speaker": "Pilot", "text": "The route is rough, and we haven't tested the landing site. We could return with something valuable—or lose the supplies."},
		{"speaker": "You", "text": "What do you need to launch?"},
		{"speaker": "Pilot", "text": "A Spaceport expedition, plus ten Aluminum and ten Hydrogen for the ship. Then we take our chances."}
	],
	"bank_loan": [
		{"speaker": "Banker", "text": "Your colony could grow faster with a little capital up front."},
		{"speaker": "You", "text": "You're offering us a loan?"},
		{"speaker": "Banker", "text": "Forty Kristals now. Repayment is due in eight weeks, with interest."},
		{"speaker": "You", "text": "And if we can't repay it?"},
		{"speaker": "Banker", "text": "Then the debt grows. It is a useful opportunity, provided you can manage the risk."}
	],
	"shift_burnout": [
		{"speaker": "Shift Supervisor", "text": "The workers are exhausted. Several have asked to stop taking extra shifts."},
		{"speaker": "You", "text": "Is it bad enough that they'll walk out?"},
		{"speaker": "Shift Supervisor", "text": "Some are already talking about a strike. They're tired of finishing a shift with nowhere to eat or rest."},
		{"speaker": "You", "text": "What can we offer them?"},
		{"speaker": "Shift Supervisor", "text": "A Medium Shop would help. Or we could shorten the shifts and give people more time to recover."}
	],
	"bigger_kitchen": [
		{"speaker": "Baker", "text": "My little shop is doing well, but I can't afford the materials to expand the kitchen."},
		{"speaker": "You", "text": "What kind of help are you asking for?"},
		{"speaker": "Baker", "text": "You could lend me the money, build the larger shop with me, or let me stay small."},
		{"speaker": "You", "text": "What would each option mean for the colony?"},
		{"speaker": "Baker", "text": "A loan earns interest. A partnership gives you a share of the shop's output. If you decline, I'll keep working with what I have."}
	],
	"water_rations": [
		{"speaker": "Resident", "text": "The taps are running low again. People are starting to argue over water."},
		{"speaker": "You", "text": "How much time do we have before it becomes a serious problem?"},
		{"speaker": "Resident", "text": "Not much. The shopkeepers are already rationing what they can spare."},
		{"speaker": "You", "text": "Can we bring in more water?"},
		{"speaker": "Resident", "text": "Water tiles could help, but they take Oxygen and Hydrogen to make. Please don't wait until the taps run dry."}
	],
	"miners_union": [
		{"speaker": "Miner Representative", "text": "The miners want to organize a union and improve safety underground."},
		{"speaker": "You", "text": "What brought this to a head?"},
		{"speaker": "Miner Representative", "text": "Too many close calls. We keep going back into unsafe tunnels because production targets don't wait."},
		{"speaker": "You", "text": "What are you asking me to do?"},
		{"speaker": "Miner Representative", "text": "Recognize the union, or spend Iron and Aluminum on better safety gear. We need to know our lives matter as much as the quota."}
	],
	"festival_day": [
		{"speaker": "Shop Owner", "text": "The colony could use a reason to celebrate."},
		{"speaker": "You", "text": "You want to hold a festival?"},
		{"speaker": "Shop Owner", "text": "A small one. People are tired, and lately all anyone talks about is work and shortages."},
		{"speaker": "You", "text": "What would it cost to put together?"},
		{"speaker": "Shop Owner", "text": "Ten Kristals and five Hydrogen for lights and cooking. I think the whole colony would feel the difference."}
	]
}


## Possible weekly events. The UI displays text; the week system applies effect_type.
const WEEKLY_EVENTS: Array[Dictionary] = [
	{
		"id": "oxygen_delivery_cut",
		"type": "SUPPLY PROBLEM",
		"title": "Delayed Oxygen Shipment",
		"description": "An Empire cargo ship has been delayed.",
		"effect_description": "No outside Oxygen arrives this week.",
		"effect_type": "pause_external_delivery",
		"resource": "oxygen"
	},
	{
		"id": "harvester_instability",
		"type": "SYSTEM FAILURE",
		"title": "Unstable Harvester",
		"description": "A harvester is vibrating beyond its safe operating limit.",
		"effect_description": "The affected harvester is destabilized and needs attention.",
		"effect_type": "destabilize_building",
		"target_category": "resource_gathering"
	},
	{
		"id": "dust_storm_damage",
		"type": "COLONY DAMAGE",
		"title": "Dust Storm Damage",
		"description": "A dust storm has swept across the colony.",
		"effect_description": "A building is damaged and may need repairs.",
		"effect_type": "damage_building",
		"target_selection": "random"
	},
	{
		"id": "new_resource_deposit",
		"type": "GOOD NEWS",
		"title": "Surveyors Find a Deposit",
		"description": "A survey team has found a previously unknown resource deposit.",
		"effect_description": "A new deposit is available for development.",
		"effect_type": "discover_deposit"
	},
	{
		"id": "worker_shortage",
		"type": "WORKFORCE",
		"title": "Workers Need Rest",
		"description": "Several workers have reported exhaustion after a demanding week.",
		"effect_description": "Morale and workforce availability may be affected.",
		"effect_type": "workforce_disruption"
	}
]


## Placeholder research definitions; set costs and rules when the team designs the tech tree.
const TECHNOLOGIES: Array[Dictionary] = [
	{"id": "advanced_oxygen", "name": "Advanced Oxygen Systems", "description": "Unlocks improved Oxygen Pumps.", "cost": {}, "cost_tbd": true, "unlocks": ["medium_oxygen_pump", "large_oxygen_pump"]},
	{"id": "atmospheric_engineering", "name": "Atmospheric Engineering", "description": "Unlocks more advanced atmospheric terraforming.", "cost": {}, "cost_tbd": true, "unlocks": ["co2_factory", "medium_nitrogen_pump", "large_nitrogen_pump"]},
	{"id": "expedition_planning", "name": "Expedition Planning", "description": "Improves the colony's ability to fund and run expeditions.", "cost": {}, "cost_tbd": true, "unlocks": ["spaceport"]}
]


## Playable leader classes shown on the character select screen.
## starting_bonus is added to STARTING_STATE resources when a new game begins.
## level_bonus is what the LevelUpPopup displays; its gameplay effect is still TBD.
const PLAYER_CLASSES: Array[Dictionary] = [
	{
		"id": "engineer",
		"name": "Engineer",
		"perk": "Starts with extra building materials.",
		"primary_stat": "engineering",
		"starting_stats": {"engineering": 3, "science": 1, "leadership": 1, "negotiation": 1},
		"starting_bonus": {"carbon": 5, "aluminum": 3},
		"level_bonus": {"name": "Construction efficiency", "amount": 5.0}
	},
	{
		"id": "scientist",
		"name": "Scientist",
		"perk": "Starts with extra gases for terraforming.",
		"primary_stat": "science",
		"starting_stats": {"engineering": 1, "science": 3, "leadership": 1, "negotiation": 1},
		"starting_bonus": {"oxygen": 5, "hydrogen": 5},
		"level_bonus": {"name": "Research speed", "amount": 5.0}
	},
	{
		"id": "diplomat",
		"name": "Diplomat",
		"perk": "Starts with extra Kristals from Empire contacts.",
		"primary_stat": "negotiation",
		"starting_stats": {"engineering": 1, "science": 1, "leadership": 1, "negotiation": 3},
		"starting_bonus": {"kristals": 10},
		"level_bonus": {"name": "Negotiation power", "amount": 5.0}
	},
	{
		"id": "commander",
		"name": "Commander",
		"perk": "Starts with extra metals for heavy projects.",
		"primary_stat": "leadership",
		"starting_stats": {"engineering": 1, "science": 1, "leadership": 3, "negotiation": 1},
		"starting_bonus": {"iron": 5, "copper": 5},
		"level_bonus": {"name": "Crew morale", "amount": 5.0}
	}
]


## ---------------------------------------------------------------------------
## Game rule numbers. These are placeholder values for balancing; change them
## here instead of inside scripts.
## ---------------------------------------------------------------------------

## Values a new playthrough starts with.
const STARTING_STATE: Dictionary = {
	"total_weeks": 52,
	"population": 1000,
	"morale": 100,
	"resources": {
		"kristals": 5, "oxygen": 5, "nitrogen": 5, "hydrogen": 5, "carbon": 5,
		"iron": 5, "copper": 5, "aluminum": 5, "risium": 5
	}
}

## Colony map size in tiles.
const MAP_COLUMNS: int = 5
const MAP_ROWS: int = 4
const DEFAULT_TERRAIN: String = "Flat"

## Limited outside support from the Empire, received every week.
const WEEKLY_SUPPLY: Dictionary = {"kristals": 5, "oxygen": 2, "risium": 2}

## Resources the colony consumes every week regardless of buildings.
const WEEKLY_UPKEEP: Dictionary = {"oxygen": 2}

## Morale lost each week for every resource the colony could not fully pay upkeep for.
const SHORTAGE_MORALE_PENALTY: int = 10

## Risium quota results. The quota amount itself comes from make_risium_quest().
const QUOTA_SUCCESS_EFFECTS: Dictionary = {"kristals": 10, "xp": 10}
const QUOTA_FAILURE_EFFECTS: Dictionary = {"morale": -10}

## Applied when an accepted villager quest passes its deadline unfinished.
const QUEST_FAILURE_EFFECTS: Dictionary = {"morale": -5}
const QUEST_COMPLETION_XP: int = 25
const BUILD_XP: int = 5
const RESEARCH_XP: int = 15

## XP needed to go from level N to N + 1 is XP_PER_LEVEL * N.
const XP_PER_LEVEL: int = 100

## Repairing a damaged or unstable building costs this fraction of its build cost (rounded up).
const REPAIR_COST_FRACTION: float = 0.5


## Returns a copy so runtime code cannot accidentally change the catalog entry.
func get_quest_by_id(quest_id: String) -> Dictionary:
	for quest in VILLAGER_QUESTS:
		if quest.get("id", "") == quest_id:
			return quest.duplicate(true)
	return {}


func get_dialogue(quest_id: String) -> Array:
	return QUEST_DIALOGUE.get(quest_id, []).duplicate(true)


func get_random_villager_quest(excluded_ids: Array = []) -> Dictionary:
	var choices: Array[Dictionary] = []

	for quest in VILLAGER_QUESTS:
		if quest.get("id", "") not in excluded_ids:
			choices.append(quest)

	if choices.is_empty():
		return {}

	return choices.pick_random().duplicate(true)


func get_building_by_id(building_id: String) -> Dictionary:
	for building in BUILDINGS:
		if building.get("id", "") == building_id:
			return building.duplicate(true)
	return {}


func get_character_by_id(character_id: String) -> Dictionary:
	for character in CHARACTERS:
		if character.get("id", "") == character_id:
			return character.duplicate(true)
	return {}


func get_random_weekly_event(excluded_ids: Array = []) -> Dictionary:
	var choices: Array[Dictionary] = []

	for event in WEEKLY_EVENTS:
		if event.get("id", "") not in excluded_ids:
			choices.append(event)

	if choices.is_empty():
		return {}

	return choices.pick_random().duplicate(true)


func make_risium_quest(week: int) -> Dictionary:
	var starting_quota: int = 3
	var increase_per_week: int = 2
	var amount: int = starting_quota + ((week - 1) * increase_per_week)

	return {
		"id": "risium_quota_week_%d" % week,
		"character_id": "empire_rep",
		"title": "Company Risium Quota",
		"description": "The Galaktik Empire requires a Risium delivery this week.",
		"objective": "Deliver %d Risium" % amount,
		"objective_type": "deliver",
		"target": "risium",
		"amount": amount,
		"deadline_weeks": 0,
		"reward": "Funding for the colony"
	}


func get_player_class(class_id: String) -> Dictionary:
	for player_class in PLAYER_CLASSES:
		if player_class.get("id", "") == class_id:
			return player_class.duplicate(true)
	return {}


func get_technology_by_id(tech_id: String) -> Dictionary:
	for tech in TECHNOLOGIES:
		if tech.get("id", "") == tech_id:
			return tech.duplicate(true)
	return {}


func get_resource_name(resource_id: String) -> String:
	return RESOURCES.get(resource_id, {}).get("name", resource_id.capitalize())


## Turns {"kristals": 5, "carbon": 3} into "5 Kristals, 3 Carbon".
func format_cost(cost: Dictionary) -> String:
	if cost.is_empty():
		return "Free"
	var parts: PackedStringArray = []
	for resource_id in cost:
		parts.append("%d %s" % [int(cost[resource_id]), get_resource_name(resource_id)])
	return ", ".join(parts)


## Turns reward effects like {"kristals": 5, "morale": 5} into "+5 Kristals, +5 Morale".
func format_effects(effects: Dictionary) -> String:
	var parts: PackedStringArray = []
	for key in effects:
		var amount: int = int(effects[key])
		var label: String = "XP" if key == "xp" else get_resource_name(key)
		parts.append("%+d %s" % [amount, label])
	return ", ".join(parts)
