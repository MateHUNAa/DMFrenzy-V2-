return {
	General = {
		name = 'Shop',
		inventory = {
			{ name = 'WEAPON_SFXD',        price = 14, currency = "MONEY"},
			{ name = 'WEAPON_DMFCOMBAT',        price = 15, currency = "MONEY" },
			{ name = 'WEAPON_fnx45',        price = 20, currency = "MONEY" },
			{ name = 'WEAPON_GC18',      price = 29, currency = "MONEY" },
			{ name = 'WEAPON_machinepistol', price = 35, currency = "MONEY" },

			{ name = 'WEAPON_HEAVYPISTOL',   price =14, currency = "MONEY" },
			{ name = 'WEAPON_PISTOL_MK2',    price =12, currency = "MONEY" },


			{ name = 'armour',               price = 5, currency = "MONEY" },
			{ name = 'bandage',              price = 5, currency = "MONEY" },
			{ name = 'suppresor',            price = 5, currency = "MONEY" },
		},
	},

	Ppshop = {
		name = 'VIP SHOP',
		inventory = {
			{ name = 'WEAPON_VIPGLOCK',  price = 50 , currency = "BLACK_MONEY"},
			{ name = 'WEAPON_GC5GEN',  price = 80 , currency = "BLACK_MONEY"},
			{ name = 'WEAPON_DEADNIGHT',  price = 65 , currency = "BLACK_MONEY"},
		},
	},

--[[ 	cayobolt = {
		name = 'cayobolt',
		blip = {
			id = 59, colour = 69, scale = 0.8
		},
		inventory = {
			{ name = 'WEAPON_TECPISTOL',     price = 16000 },
			{ name = 'WEAPON_ADVANCEDRIFLE', price = 17000 },
			{ name = 'WEAPON_ASSAULTSMG',    price = 39000 },
			{ name = 'WEAPON_BULLPUPRIFLE',  price = 37000 },
			{ name = 'WEAPON_COMBATMG',      price = 60000 },
			{ name = 'WEAPON_MILITARYRIFLE', price = 25000 },
		}
	}, ]]

	Vehicle = {
		name = "Vehicle Shop",
		inventory = {
			{
				name = "vehicle",
				price = 30,
				metadata = {
					model = "jugular",
					label = "Jugular",
					image = 'jugular'
				}
				, currency = "MONEY"
			},
			{
				name = "vehicle",
				price = 20,
				metadata = {
					model = "akuma",
					label = "Akuma",
					image = 'akuma'
				}
				, currency = "MONEY"
			},
		},
	},
}
