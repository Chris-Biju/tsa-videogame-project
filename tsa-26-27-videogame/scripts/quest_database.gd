extends RefCounted
## Dictionary that holds all vilager quests to be selected
## WORK: Need to differentiate between quest difficulties
const VILLAGER_QUESTS: Array[Dictionary] = [
	{
		"id": "build_shop",
		"title": "A Place to Rest",
		"description": "A worker asks for a small shop near the mining area.",
		"objective": "Build 1 Small Shop",
		"deadline_weeks": 3,
		"reward": "5 Kristals and +5 morale",
		"status": "In progress"
	},
	{
		"id": "hungry_stoves",
		"title": "Cold Stoves",
		"description": "A shop owner is running out of hydrogen and can't keep the stoves lit.",
		"objective": "Deliver 5 Hydrogen to the Small Shop",
		"deadline_weeks": 2,
		"reward": "Shop output +5 and +5 morale",
		"status": "In progress"
	},
	{
		"id": "missing_copper",
		"title": "The Missing Shipment",
		"description": "A dockworker swears a copper shipment never reached storage. Everyone's story is slightly different.",
		"objective": "Talk to 3 citizens and name the culprit",
		"deadline_weeks": 3,
		"reward": "10 Copper and a new ally",
		"status": "In progress"
	},
	{
		"id": "garden_dreams",
		"title": "Garden Dreams",
		"description": "A retired botanist wants a place where something green can grow.",
		"objective": "Build 1 Garden",
		"deadline_weeks": 5,
		"reward": "+10 morale and a discount on biomass tiles",
		"status": "In progress"
	},
	{
		"id": "breathing_tax",
		"title": "The Breathing Tax",
		"description": "Squatters on the outskirts are drowning in oxygen costs, and their leader asks for help.",
		"objective": "Build 1 Small Oxygen Pump in the outskirts",
		"deadline_weeks": 4,
		"reward": "+20 morale and settlement loyalty",
		"status": "In progress"
	},
	{
		"id": "dust_storm_prep",
		"title": "Storm on the Horizon",
		"description": "The weather officer warns a dust storm will hit soon and the harvesters are exposed.",
		"objective": "Stockpile 15 Oxygen and reinforce 3 buildings",
		"deadline_weeks": 2,
		"reward": "No storm damage",
		"status": "In progress"
	},
	{
		"id": "mine_collapse",
		"title": "Trapped Below",
		"description": "A tunnel has collapsed with miners still inside, and the foreman is begging for rescue gear.",
		"objective": "Spend 5 Aluminum and 3 Copper on rescue equipment",
		"deadline_weeks": 1,
		"reward": "Miners saved, +10 morale, and workforce loyalty",
		"status": "In progress"
	},
	{
		"id": "oxygen_leak",
		"title": "Something's Hissing",
		"description": "The safety engineer detects an oxygen leak but can't tell which of three buildings it's coming from.",
		"objective": "Question the engineer and 2 residents, then seal the correct building",
		"deadline_weeks": 2,
		"reward": "Oxygen loss stopped and 5 Kristals",
		"status": "In progress"
	},
	{
		"id": "rebellion_brewing",
		"title": "Whispers in the Dark",
		"description": "A rebel sympathizer warns that a protest is being planned and morale is low.",
		"objective": "Raise morale above 60 or negotiate with the protest leaders",
		"deadline_weeks": 3,
		"reward": "Protest cancelled and +15 morale",
		"status": "In progress"
	},
	{
		"id": "new_deposit",
		"title": "Strike It Rich",
		"description": "Surveyors found a Risium deposit, but a rival mining crew is already eyeing it.",
		"objective": "Build 1 Risium Harvester at the deposit",
		"deadline_weeks": 2,
		"reward": "+5 Risium per week",
		"status": "In progress"
	},
	{
		"id": "landlord_offer",
		"title": "The Landlord's Offer",
		"description": "Blackstone will fund a Skyscraper if you let them raise rents. The settlements won't like it.",
		"objective": "Build 1 Skyscraper",
		"deadline_weeks": 6,
		"reward": "50 Kristals and +100 output, but -20 morale in the settlements",
		"status": "In progress"
	},
	{
		"id": "underground_trade",
		"title": "No Questions Asked",
		"description": "A smuggler offers cheap oxygen cylinders to the squatters. It's illegal, but it works.",
		"objective": "Decide to allow, shut down, or tax the smuggling operation",
		"deadline_weeks": 2,
		"reward": "Depends on your choice: +10 morale, +10 citizen trust, or 20 Kristals",
		"status": "In progress"
	},
	{
		"id": "spaceport_gamble",
		"title": "Into the Void",
		"description": "A pilot proposes an expedition for rare materials. It could pay off big or lose everything.",
		"objective": "Fund 1 Spaceport expedition with 10 Aluminum and 10 Hydrogen",
		"deadline_weeks": 4,
		"reward": "1 rare tech component",
		"status": "In progress"
	},
	{
		"id": "bank_loan",
		"title": "Borrowed Time",
		"description": "The banker offers fast cash at a high interest rate, due in 8 weeks.",
		"objective": "Accept the loan and repay it in full",
		"deadline_weeks": 8,
		"reward": "40 Kristals upfront to build faster",
		"status": "In progress"
	},
	{
		"id": "shift_burnout",
		"title": "Running on Empty",
		"description": "The shift supervisor says the workers are exhausted and a strike is likely.",
		"objective": "Build 1 Medium Shop or choose shorter shifts",
		"deadline_weeks": 3,
		"reward": "+15 morale and +10 output for 4 weeks",
		"status": "In progress"
	},
	{
		"id": "bigger_kitchen",
		"title": "A Bigger Kitchen",
		"description": "A baker wants to expand into a larger shop but can't afford the aluminum.",
		"objective": "Choose to give a loan, build it yourself as a partner, or decline",
		"deadline_weeks": 4,
		"reward": "Loan: interest income. Partnership: you build the shop and take 20% of its output. Decline: nothing.",
		"status": "In progress"
	},
	{
		"id": "water_rations",
		"title": "Dry Taps",
		"description": "Residents report that the water supply is running thin and tempers are rising.",
		"objective": "Place 2 water tiles using Oxygen and Hydrogen",
		"deadline_weeks": 3,
		"reward": "+10 morale and 5 Kristals from grateful shopkeepers",
		"status": "In progress"
	},
	{
		"id": "miners_union",
		"title": "Safety First",
		"description": "The miners want a union and better safety gear after too many close calls.",
		"objective": "Recognize the union or spend 10 Iron and 5 Aluminum on gear upgrades",
		"deadline_weeks": 4,
		"reward": "+15 morale and fewer accidents for 6 weeks",
		"status": "In progress"
	},
	{
		"id": "festival_day",
		"title": "A Reason to Celebrate",
		"description": "Shop owners want to throw a colony-wide festival to lift everyone's spirits.",
		"objective": "Spend 10 Kristals and 5 Hydrogen on a festival",
		"deadline_weeks": 2,
		"reward": "+20 morale for 3 weeks",
		"status": "In progress"
	}
]
## sets the company quota of risium for the week
static func make_risium_quest(week: int) -> Dictionary:
	var amount := 3 + ((week-1)*2)
	return {
		"id": "risium_quota_week_%d" % week,
		"title": "Company Risium Quota",
		"description": "The Galaktik Empire requires a Risium delivery this week.",
		"objective": "Deliver %d Risium" % amount,
		"deadline_weeks": 0,
		"reward": "Funding for the colony",
		"status": "In progress"
	}
