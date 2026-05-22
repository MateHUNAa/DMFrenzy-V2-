return {
	['testburger'] = {
		label = 'Test Burger',
		weight = 220,
		degrade = 60,
		client = {
			image = 'burger_chicken.png',
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			export = 'ox_inventory_examples.testburger'
		},
		server = {
			export = 'ox_inventory_examples.testburger',
			test = 'what an amazingly delicious burger, amirite?'
		},
		buttons = {
			{
				label = 'Lick it',
				action = function(slot)
					print('You licked the burger')
				end
			},
			{
				label = 'Squeeze it',
				action = function(slot)
					print('You squeezed the burger :(')
				end
			},
			{
				label = 'What do you call a vegan burger?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('A misteak.')
				end
			},
			{
				label = 'What do frogs like to eat with their hamburgers?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('French flies.')
				end
			},
			{
				label = 'Why were the burger and fries running?',
				group = 'Hamburger Puns',
				action = function(slot)
					print('Because they\'re fast food.')
				end
			}
		},
		consume = 0.3
	},

	--[[ 	['bandage'] = {
		label = 'Bandage',
		weight = 115,
		client = {
			anim = { dict = 'missheistdockssetup1clipboard@idle_a', clip = 'idle_a', flag = 49 },
			prop = { model = `prop_rolled_sock_02`, pos = vec3(-0.14, -0.14, -0.08), rot = vec3(-50.0, -50.0, 0.0) },
			disable = { move = true, car = true, combat = true },
			usetime = 2500,
		}
	}, ]]


	['ruhaticket'] = {
		label = 'Egyedi Ruha Ticket',
		weight = 1,
		stack = false,
	},
	['fegyverticket'] = {
		label = 'Egyedi fegyver Ticket',
		weight = 1,
		stack = false,
	},
	['egyediauto'] = {
		label = 'Egyedi Autó Ticket',
		weight = 1,
		stack = false,
	},
	['frakiticket'] = {
		label = 'Frakció Ticket',
		weight = 1,
		stack = false,
	},



	['black_money'] = {
		label = 'Void Coin',
	},

	['burger'] = {
		label = 'Burger',
		weight = 220,
		client = {
			status = { hunger = 200000 },
			anim = 'eating',
			prop = 'burger',
			usetime = 2500,
			notification = 'You ate a delicious burger'
		},
	},

	['sprunk'] = {
		label = 'Sprunk',
		weight = 350,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_can_01`, pos = vec3(0.01, 0.01, 0.06), rot = vec3(5.0, 5.0, -180.5) },
			usetime = 2500,
			notification = 'You quenched your thirst with a sprunk'
		}
	},

	['parachute'] = {
		label = 'Parachute',
		weight = 8000,
		stack = false,
		client = {
			anim = { dict = 'clothingshirt', clip = 'try_shirt_positive_d' },
			usetime = 1500
		}
	},

	['garbage'] = {
		label = 'Garbage',
	},

	['paperbag'] = {
		label = 'Paper Bag',
		weight = 1,
		stack = false,
		close = false,
		consume = 0
	},

	['identification'] = {
		label = 'Identification',
		client = {
			image = 'card_id.png'
		}
	},

	['panties'] = {
		label = 'Knickers',
		weight = 10,
		consume = 0,
		client = {
			status = { thirst = -100000, stress = -25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_cs_panties_02`, pos = vec3(0.03, 0.0, 0.02), rot = vec3(0.0, -13.5, -1.5) },
			usetime = 2500,
		}
	},

	['lockpick'] = {
		label = 'Lockpick',
		weight = 160,
	},

	['phone'] = {
		label = 'Phone',
		weight = 190,
		stack = false,
		consume = 0,
		client = {
			add = function(total)
				if total > 0 then
					pcall(function() return exports.npwd:setPhoneDisabled(false) end)
				end
			end,

			remove = function(total)
				if total < 1 then
					pcall(function() return exports.npwd:setPhoneDisabled(true) end)
				end
			end
		}
	},

	['money'] = {
		label = 'BloodCoin',
	},

	['mustard'] = {
		label = 'Mustard',
		weight = 500,
		client = {
			status = { hunger = 25000, thirst = 25000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_food_mustard`, pos = vec3(0.01, 0.0, -0.07), rot = vec3(1.0, 1.0, -1.5) },
			usetime = 2500,
			notification = 'You.. drank mustard'
		}
	},

	['water'] = {
		label = 'Water',
		weight = 500,
		client = {
			status = { thirst = 200000 },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			prop = { model = `prop_ld_flow_bottle`, pos = vec3(0.03, 0.03, 0.02), rot = vec3(0.0, 0.0, -1.5) },
			usetime = 2500,
			cancel = true,
			notification = 'You drank some refreshing water'
		}
	},

	['radio'] = {
		label = 'Radio',
		weight = 1000,
		stack = false,
		allowArmed = true
	},

	['armour'] = {
		label = 'Shield',
		weight = 1,
		stack = true,
		client = {
			disable = { move = false, car = false, combat = false },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			usetime = 1200
		}
	},

	['clothing'] = {
		label = 'Clothing',
		consume = 0,
	},

	['mastercard'] = {
		label = 'Fleeca Card',
		stack = false,
		weight = 10,
		client = {
			image = 'card_bank.png'
		}
	},

	['scrapmetal'] = {
		label = 'Scrap Metal',
		weight = 80,
	},

	["alive_chicken"] = {
		label = "Living chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["blowpipe"] = {
		label = "Blowtorch",
		weight = 2,
		stack = true,
		close = true,
	},

	["bread"] = {
		label = "Bread",
		weight = 1,
		stack = true,
		close = true,
	},

	["cannabis"] = {
		label = "Cannabis",
		weight = 3,
		stack = true,
		close = true,
	},

	["carokit"] = {
		label = "Body Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["carotool"] = {
		label = "Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["clothe"] = {
		label = "Cloth",
		weight = 1,
		stack = true,
		close = true,
	},

	["copper"] = {
		label = "Copper",
		weight = 1,
		stack = true,
		close = true,
	},

	["cutted_wood"] = {
		label = "Cut wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["diamond"] = {
		label = "Diamond",
		weight = 1,
		stack = true,
		close = true,
	},

	["essence"] = {
		label = "Gas",
		weight = 1,
		stack = true,
		close = true,
	},

	["fabric"] = {
		label = "Fabric",
		weight = 1,
		stack = true,
		close = true,
	},

	["fish"] = {
		label = "Fish",
		weight = 1,
		stack = true,
		close = true,
	},

	["fixkit"] = {
		label = "Repair Kit",
		weight = 3,
		stack = true,
		close = true,
	},

	["fixtool"] = {
		label = "Repair Tools",
		weight = 2,
		stack = true,
		close = true,
	},

	["gazbottle"] = {
		label = "Gas Bottle",
		weight = 2,
		stack = true,
		close = true,
	},

	["gold"] = {
		label = "Gold",
		weight = 1,
		stack = true,
		close = true,
	},

	["iron"] = {
		label = "Iron",
		weight = 1,
		stack = true,
		close = true,
	},

	["marijuana"] = {
		label = "Marijuana",
		weight = 2,
		stack = true,
		close = true,
	},

	["bandage"] = {
		label = "Heal",
		weight = 1,
		stack = true,
		client = {
			disable = { move = false, car = false, combat = false },
			anim = { dict = 'mp_player_intdrink', clip = 'loop_bottle' },
			usetime = 1200
		}
	},

	["packaged_chicken"] = {
		label = "Chicken fillet",
		weight = 1,
		stack = true,
		close = true,
	},

	["packaged_plank"] = {
		label = "Packaged wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol"] = {
		label = "Oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["petrol_raffin"] = {
		label = "Processed oil",
		weight = 1,
		stack = true,
		close = true,
	},

	["slaughtered_chicken"] = {
		label = "Slaughtered chicken",
		weight = 1,
		stack = true,
		close = true,
	},

	["stone"] = {
		label = "Stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["washed_stone"] = {
		label = "Washed stone",
		weight = 1,
		stack = true,
		close = true,
	},

	["wood"] = {
		label = "Wood",
		weight = 1,
		stack = true,
		close = true,
	},

	["wool"] = {
		label = "Wool",
		weight = 1,
		stack = true,
		close = true,
	},

	["medikit"] = {
		label = "Medikit",
		weight = 2,
		stack = true,
		close = true,
	},

	["box"] = {
		label = "Surprise Box",
		weight = 1,
		stack = true,
		close = true,
	},

	["handcuffs"] = {
		label = "Handcuffs",
		weight = 1,
		stack = true,
		close = true,
	},

	["sponge"] = {
		label = "Sponge",
		weight = 1,
		stack = true,
		close = true,
	},

	["vehicle"] = { -- vehCard
		label      = "Vehicle",
		weight     = 1,
		stack      = false,
		close      = true,
		client     = {
			export = "dmf-core.vehicle",
		}
	},

	["ak47belso"] = {
		label = "AK47 belsőszerkezet",
		weight = 1,
		stack = true,
		close = true,
	},

	["ak47cso"] = {
		label = "AK47 cső",
		weight = 1,
		stack = true,
		close = true,
	},

	["ak47ravasz"] = {
		label = "AK47 ravasz",
		weight = 1,
		stack = true,
		close = true,
	},

	["ak47tar"] = {
		label = "AK47 tár",
		weight = 1,
		stack = true,
		close = true,
	},

	["ak47valtamasz"] = {
		label = "AK47 válltámasz",
		weight = 1,
		stack = true,
		close = true,
	},

	["pistolbelso"] = {
		label = "Pisztoly belsőszerkezet",
		weight = 0,
		stack = true,
		close = true,
	},

	["pistolcso"] = {
		label = "Pisztoly cső",
		weight = 0,
		stack = true,
		close = true,
	},

	["pistoltar"] = {
		label = "Pisztoly tár",
		weight = 0,
		stack = true,
		close = true,
	},

	["shotgunbelso"] = {
		label = "UTAS UTS-15 belsőszerkezet",
		weight = 1,
		stack = true,
		close = true,
	},

	["shotguncso"] = {
		label = "UTAS UTS-15 cső",
		weight = 1,
		stack = true,
		close = true,
	},

	["shotgunravasz"] = {
		label = "UTAS UTS-15 ravasz",
		weight = 1,
		stack = true,
		close = true,
	},

	["shotguntar"] = {
		label = "UTAS UTS-15 tár",
		weight = 1,
		stack = true,
		close = true,
	},

	["shotgunvaltamasz"] = {
		label = "UTAS UTS-15 válltámasz",
		weight = 1,
		stack = true,
		close = true,
	},

	["tec9belso"] = {
		label = "TEC9 belsőszerkezet",
		weight = 0,
		stack = true,
		close = true,
	},

	["tec9cso"] = {
		label = "TEC9 cső",
		weight = 0,
		stack = true,
		close = true,
	},

	["tec9tar"] = {
		label = "TEC9 tár",
		weight = 0,
		stack = true,
		close = true,
	},

	["uzibelso"] = {
		label = "Micro SMG belsőszerkezet",
		weight = 1,
		stack = true,
		close = true,
	},

	["uzicso"] = {
		label = "Micro SMG cső",
		weight = 1,
		stack = true,
		close = true,
	},

	["uziravasz"] = {
		label = "Micro SMG ravasz",
		weight = 1,
		stack = true,
		close = true,
	},

	["uzitar"] = {
		label = "Micro SMG tár",
		weight = 1,
		stack = true,
		close = true,
	},
}