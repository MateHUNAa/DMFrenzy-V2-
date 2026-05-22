Config = {
	Locale = GetConvar("esx:locale", "hu"),
}
if not Translate then
	Translate = _
end

COMSERV = {
	outCoords = {
		Enable = true,
		Coords = vector3(900.1181, -56.8438, 78.7574),
	},
	coords = vector3(3065.1409, -4742.8711, 15.2616),
	radius = 40,

	marker = {
		typ = 1,
		size = 1.5,
		upDown = false,
		color = { 12, 166, 120, 150 },
	},

	blip = {
		icon = 1,
		name = "Közi",
	},

	model = GetHashKey("prop_tool_broom"),
}

JAIL = {
	cells = {
		vector3(1691.9890, 2634.6902, 45.5649),
		vector3(1685.2516, 2635.5488, 45.5649),
		vector3(1686.2542, 2642.6038, 45.5649),
		vector3(1692.6523, 2644.3291, 45.5649),
	},
	outCoords = vector3(222.1720, -799.8480, 30.6841),
	distance = 3,
}

ADMIN_RANKS = {
    ['owner'] = true,
    ['dev'] = true,
	['subdev'] = true,
    ['servmanager'] = true,
    ['cmanager'] = true,
    ['adminc'] = true,
    ['sadmin'] = true,
    ['admin'] = true,
    ['helper'] = true
}

-- WEBHOOK = false --discord log is disabled
WEBHOOK = "https://discord.com/api/webhooks/1352985148148289626/pqePxuZXWA8zH8GpWmDfvW48VNGxgBZRlJBzNYydHDqZqobTPXEypgnr33wEYmGs__AT" --your webhook here

function output(text, target)
	if IsDuplicityVersion() then --Server Side
		TriggerClientEvent('chat:addMessage', target or -1, {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Közmunka]: ^5'..text..'</div>'
		})
	else
		TriggerEvent('chat:addMessage', {
			template = '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Közmunka]: ^5'..text..'</div>'
		})
	end
end

if not IsDuplicityVersion() then --Server side
	return
end

function isAdmin(xPlayer)
	if type(xPlayer) ~= "table" then
		xPlayer = ESX.GetPlayerFromId(xPlayer)
	end

	if not xPlayer then
		return false
	end

	local permissions = ADMIN_RANKS[xPlayer.getGroup()]

	if not permissions then
		output(Translate("not_admin"), xPlayer.source)
	end

	return permissions
end
