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


static func get_dialogue(quest_id: String) -> Array:
	return QUEST_DIALOGUE.get(quest_id, [])
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
