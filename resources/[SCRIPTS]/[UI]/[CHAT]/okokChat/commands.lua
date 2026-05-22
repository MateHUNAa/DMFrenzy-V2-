ESX = exports["es_extended"]:getSharedObject()
mCore = exports["mCore"]:getSharedObj()
local canAdvertise = true

if Config.AllowPlayersToClearTheirChat then
	RegisterCommand(Config.ClearChatCommand, function(source, args, rawCommand)
		TriggerClientEvent('chat:client:ClearChat', source)
	end, false)
end

if Config.AllowStaffsToClearEveryonesChat then
	RegisterCommand(Config.ClearEveryonesChatCommand, function(source, args, rawCommand)
		local isAdmin = exports["mate-admin"]:isAdmin(source)
		if isAdmin then
			TriggerClientEvent('chat:client:ClearChat', -1)
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div style="padding: 0.4vw; margin: 0.4vw; relaitve; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 0.5rem;"><span style="color: black"><span style="background-color: #ffa500; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900"><i class="fa-solid fa-circle-info"></i> Rendszer</span><span style="color:white; font-weight: 900"> Egy adminisztrátor kiürítette a chatet. </span></span></div>',
				args = { time, message }
			})
		end
	end, false)
end



function getDiscordId(source)
	local discordId = GetPlayerIdentifierByType(source, 'discord')
	if discordId then
		local extractedId = discordId:match("discord:(%d+)")
		return extractedId
	end
	return nil
end

function IsDiscordIdVIP(discordId)
	exports["mate-vipsystem"]:GetPlayerVip(discordId, function(data)
		return data
	end)
end

function IsSuperVIP(discordId)
	exports["mate-vipsystem"]:GetPlayerVipLevel(discordId, function(data)
		return data
	end)
end

if Config.EnableStaffCommand then
	RegisterCommand(Config.StaffCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.StaffCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local group = xPlayer.getGroup()
		local color = "#00FFFF"

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
		end

		if isAdmin(xPlayer) then
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div style="border: 2px solid #e65245;padding: 0.4vw; margin: 0.4vw; relaitve; width: 410px; background-color: rgba(10, 10, 10, 0.6); border-radius: 10px;"><span style="color:black;"><p style="background-color: #e65245; padding-right: 3px; padding-left: 3px; border-radius: 4px; font-style: italic; font-weight: 900; text-align: center"><i style="float: left; text-align: left" class="left fa-solid fa-triangle-exclamation"></i> Adminisztrátor felhívás <i style="float: right" class="right fa-solid fa-triangle-exclamation"></i></p><span style="color:{2}; font-weight: 900">{0}:</span></span><span style="color:white;">{1}</span></div>',
				args = { playerName, message, color }
			})
		end
	end, false)
end

RegisterCommand("lockdown", function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	playerName = xPlayer.getName()

	isAdmin(xPlayer.source, function(data)
		if data then
			TriggerEvent('mate-chat:lw', xPlayer.source)
		else
			mCore.Notify(source, "Nem vagy admin !", "[MUTE SYSTEM]", "info", 5000)
		end
	end)
end, false)

RegisterCommand(Config.StaffOnlyCommand, function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local length = string.len(Config.StaffOnlyCommand)
	local message = rawCommand:sub(length + 1)
	local time = os.date(Config.DateFormat)
	playerName = xPlayer.getName()

	local group = xPlayer.getGroup()
	local color = "#00FFFF"

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
	end

	local template =
	[[
			<div style="padding: 0.4vw; margin: 0.4vw; width: 410px; background-color: rgba(10, 10, 10, 0.7); border: 2px solid #FF5733; border-radius: 10px;">
			<span style="color: black;">
			  <span id="AdminTag" style="background-color: #FF5733; color: black; padding: 4px 8px; border-radius: 8px; margin-right: 6px; font-weight: bold; font-style: italic; box-shadow: 0 0 5px #FF5733;">
			    <i class="fa-solid fa-user-shield"></i> {2}
			  </span>
			</span>
			<b><span style="color: #FF5733;">{0}:</b></span> {1}
		   </div>
		
]]
	isAdmin(xPlayer.source, function(data)
		print(data)
		if data then
			showOnlyForAdmins(function(admins)
				TriggerClientEvent('chat:addMessage', admins, {
					template = template,
					args = { playerName, message, group, color }
				})
			end)
		end
	end)
end, false)

if Config.EnableAdvertisementCommand then
	RegisterCommand(Config.AdvertisementCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.AdvertisementCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local bankMoney = xPlayer.getAccount('bank').money

		if canAdvertise then
			if bankMoney >= Config.AdvertisementPrice then
				xPlayer.removeAccountMoney('bank', Config.AdvertisementPrice)
				TriggerClientEvent('chat:addMessage', -1, {
					template =
					'<div class="chat-message advertisement"><i class="fas fa-ad"></i> <b><span style="color: #81db44">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
					args = { playerName, message, time }
				})

				TriggerClientEvent('okokNotify:Alert', source, "Hírdetés", "Sikeresen feladtad a hírdetést.", 500,
					'success')

				local time = Config.AdvertisementCooldown * 60
				local pastTime = 0
				canAdvertise = false

				while (time > pastTime) do
					Citizen.Wait(1000)
					pastTime = pastTime + 1
					timeLeft = time - pastTime
				end
				canAdvertise = true
			else
				TriggerClientEvent('okokNotify:Alert', source, "ADVERTISEMENT",
					"You don't have enough money to make an advertisement", 10000, 'error')
			end
		else
			TriggerClientEvent('okokNotify:Alert', source, "ADVERTISEMENT", "You can't advertise so quickly", 10000,
				'error')
		end
	end)
end

if Config.EnableTwitchCommand then
	RegisterCommand(Config.TwitchCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.TwitchCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local twitch = twitchPermission(source)

		if twitch then
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div class="chat-message twitch"><i class="fab fa-twitch"></i> <b><span style="color: #9c70de">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
				args = { playerName, message, time }
			})
		end
	end)
end

function twitchPermission(id)
	for i, a in ipairs(Config.TwitchList) do
		for x, b in ipairs(GetPlayerIdentifiers(id)) do
			if string.lower(b) == string.lower(a) then
				return true
			end
		end
	end
end

if Config.EnableYoutubeCommand then
	RegisterCommand(Config.YoutubeCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.YoutubeCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local youtube = youtubePermission(source)

		if youtube then
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div class="chat-message youtube"><i class="fab fa-youtube"></i> <b><span style="color: #ff0000">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
				args = { playerName, message, time }
			})
		end
	end)
end

function youtubePermission(id)
	for i, a in ipairs(Config.YoutubeList) do
		for x, b in ipairs(GetPlayerIdentifiers(id)) do
			if string.lower(b) == string.lower(a) then
				return true
			end
		end
	end
end

if Config.EnableTwitterCommand then
	RegisterCommand(Config.TwitterCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.TwitterCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()

		TriggerClientEvent('chat:addMessage', -1, {
			template =
			'<div class="chat-message twitter"><i class="fab fa-twitter"></i> <b><span style="color: #2aa9e0">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
			args = { playerName, message, time }
		})
	end)
end

if Config.EnablePoliceCommand then
	RegisterCommand(Config.PoliceCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.PoliceCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local job = xPlayer.job.name

		if job == Config.PoliceJobName then
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div class="chat-message police"><i class="fas fa-bullhorn"></i> <b><span style="color: #4a6cfd">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
				args = { playerName, message, time }
			})
		end
	end)
end

if Config.EnableAmbulanceCommand then
	RegisterCommand(Config.AmbulanceCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.AmbulanceCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		local job = xPlayer.job.name

		if job == Config.AmbulanceJobName then
			TriggerClientEvent('chat:addMessage', -1, {
				template =
				'<div class="chat-message ambulance"><i class="fas fa-ambulance"></i> <b><span style="color: #e3a71b">{0}</span>&nbsp;<span style="font-size: 14px; color: #e1e1e1;">{2}</span></b><div style="margin-top: 5px; font-weight: 300;">{1}</div></div>',
				args = { playerName, message, time }
			})
		end
	end)
end

if Config.EnableOOCCommand then
	RegisterCommand(Config.OOCCommand, function(source, args, rawCommand)
		local xPlayer = ESX.GetPlayerFromId(source)
		local length = string.len(Config.OOCCommand)
		local message = rawCommand:sub(length + 1)
		local time = os.date(Config.DateFormat)
		playerName = xPlayer.getName()
		TriggerClientEvent('chat:ooc', -1, source, playerName, message, time)
	end)
end

RegisterCommand(Config.MuteCommand, function(source, args, rawCommand)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerName = xPlayer.getName()
	local isAdmin = exports["mate-admin"]:isAdmin(source)

	if isAdmin then
		if args[1] and args[2] then
			local targetId = tonumber(args[1])
			local durationHours = tonumber(args[2])

			if not durationHours then
				return
			end

			local targetPlayer = ESX.GetPlayerFromId(targetId)
			if targetPlayer then
				local targetIdentifer = targetPlayer.identifier
				local mutedName = targetPlayer.getName()
				local dcid = getDiscordId(targetPlayer.source)
				if not IsPlayerMuted(targetIdentifer) then
					MutePlayer(targetPlayer, durationHours, xPlayer)
				else
					mCore.Notify(source, "This player is already muted !", "[MUTE SYSTEM]", "error", 5000)
				end
			else
				mCore.Notify(source, "Invalid Target ID !", "[MUTE SYSTEM]", "error", 5000)
			end
		else
			mCore.Notify(source, "Invalid parameters for </mute <ID> <hours> >", "[MUTE SYSTEM]", "error", 5000)
		end
	else
		mCore.Notify(source, "Nem vagy admin", "[MUTE SYSTEM]", "error", 5000)
	end
end, false)

RegisterCommand("unmute", function(source, args)
	print("ASD")
	local targetId = tonumber(args[1])
	local isAdmin = exports["mate-admin"]:isAdmin(source)
	if not targetId then
		return mCore.Notify(source, "You need to specify the target! /unmute <targetId>", "[MUTE SYSTEM]", "info", 5000)
	end
	local targetPlayer = ESX.GetPlayerFromId(targetId)
	local xPlayer = ESX.GetPlayerFromId(source)

	if isAdmin then
		if targetPlayer then
			local targetIdentifier = targetPlayer.identifier
			if IsPlayerMuted(targetIdentifier) then
				unMutePlayer(targetPlayer, xPlayer)
			else
				mCore.Notify(source, "This player is not muted!", '[MUTE SYSTEM]', "info", 5000)
			end
		else
			mCore.Notify(source, "Invalid target!", "[MUTE SYSTEM]", "info", 5000)
		end
	else
		mCore.Notify(source, "You are not an admin!", "[MUTE SYSTEM]", "info", 5000)
	end
end, false)


function unMutePlayer(targetPlayer, xPlayer)
	local name = GetPlayerName(targetPlayer.source)
	local adminName = GetPlayerName(xPlayer.source)

	local webhook =
	'https://discord.com/api/webhooks/1237282821064884254/Uli-BhfudLWS1motpf2CLmsXm3a-5saeHLFAcy0yY7nWFIm6828EriU516OaZSAaQjIE'

	local data = {
		{
			color = 32768,
			title = '** [ UNMUTE ] **',
			description = string.format('Successfully unmuted **%s** by **%s**', name, adminName),
			fields = {
				{ name = 'Admin Name',        value = adminName },
				{ name = 'Admin Identifier',  value = xPlayer.identifier },
				{ name = 'Player Name',       value = name },
				{ name = 'Player Identifier', value = targetPlayer.identifier }
			},
			footer = { text = 'Made by MateHUN ♥' }
		}
	}

	local errorEmbed = {
		{
			color = 15549239,
			title = "** [ ERROR ] **",
			description = string.format('%s cannot be found in the database!', name),
			footer = { text = 'Made by MateHUN ♥' }
		}
	}

	exports.oxmysql:execute('DELETE FROM `mate-mute` WHERE mutedIdentifier = @identifier', {
		['@identifier'] = targetPlayer.identifier
	}, function(rowsChanged)
		if rowsChanged.affectedRows > 0 then
			mCore.Notify(xPlayer.source, string.format("Successfully unmuted %s!", name), "[MUTE SYSTEM]", "info",
				5000)
			exports.mCore:sendEmbed(webhook, 'MUTE LOG', data)
			mCore.Notify(targetPlayer.source, "You have been unmuted by an administrator!", '[MUTE SYSTEM]', "info",
				5000)
		else
			mCore.Notify(xPlayer.source, string.format("Something went wrong while unmuting %s", name),
				"[MUTE SYSTEM]", "info", 5000)
			exports.mCore:sendEmbed(webhook, 'MUTE LOG', errorEmbed)
		end
	end)
end

function MutePlayer(targetPlayer, duration, xPlayer)
	local currentDate = os.date('%Y-%m-%d %H:%M:%S')
	local durationHours = tonumber(duration)
	local currentTime = os.time()
	local expireTime = currentTime + (durationHours * 60 * 60)
	local expireDate = os.date('%Y-%m-%d %H:%M:%S', expireTime)
	local webhook =
	'https://discord.com/api/webhooks/1237282821064884254/Uli-BhfudLWS1motpf2CLmsXm3a-5saeHLFAcy0yY7nWFIm6828EriU516OaZSAaQjIE'


	local data = {

		{
			color = 32768,
			title = '** [ MUTE ] **',
			description = string.format('Sikeressen Muteolva lett  **%s** BY: **%s**',
				GetPlayerName(targetPlayer.source), GetPlayerName(xPlayer.source)),
			author = {
				name = '2 hour time diff'
			},
			fields = {
				{
					name = 'Admin Name',
					value = tostring(GetPlayerName(xPlayer.source))
				},
				{
					name = 'Admin Identifer',
					value = tostring(xPlayer.getIdentifier())
				},
				{
					name = 'Player Name',
					value = tostring(GetPlayerName(targetPlayer.source))
				},
				{
					name = 'Player Identifer',
					value = tostring(targetPlayer.getIdentifier())
				},
				{
					name = 'Date When Muted',
					value = tostring(currentDate)
				},
				{
					name = 'Expire at',
					value = tostring(expireDate)
				},
			},
			footer = {
				text = 'Made by MateHUN ♥'
			}
		}

	}
	local errorEmbed = {
		{
			["color"] = 15549239,
			["title"] = "**" .. '[ ERROR ]' .. "**",
			["description"] = string.format('%s Cannot be found in the database !', GetPlayerName(targetPlayer.source)),
			["footer"] = {
				["text"] = "Made by MateHUN ♥",
			},
		}
	}

	MySQL.query(
		'INSERT INTO `mate-mute` SET mutedIdentifier = ?, mutedDiscord = ?, dateMuted = ?, expire = ?, admin = ?, adminName = ?, mutedName = ?',
		{
			targetPlayer.getIdentifier(),
			getDiscordId(targetPlayer.source),
			currentDate,
			expireDate,
			xPlayer.getIdentifier(),
			GetPlayerName(xPlayer.source),
			GetPlayerName(targetPlayer.source)
		},
		function(rowsChanged) -- === {"affectedRows":0,"fieldCount":0,"serverStatus":2,"warningStatus":0,"insertId":0,"info":""}
			if rowsChanged.affectedRows > 0 then
				TriggerClientEvent('codem-notification', xPlayer.source, 'Player successfully mute!', 5000, 'check')
				exports.mCore:sendEmbed(webhook, 'MUTE LOG', data)
				mCore.Notify(targetPlayer.source, "You have been muted by an administrator !", "[MUTE SYSTEM]",
					"info", 5000)
				mCore.Notify(xPlayer.source, ("Successfully muted %s !"):format(GetPlayerName(targetPlayer.source)),
					'[MUTE SYSTEM]', "check", 5000)
			else
				TriggerClientEvent('codem-notification', xPlayer.source,
					'Something went wrong with muteing ' .. targetName .. ' !',
					5000, 'error')
				exports.mCore:sendEmbed(webhook, 'MUTE LOG', errorEmbed)
			end
		end)
end

function IsPlayerMuted(license)
	print("checking : ", license)
	local query = "SELECT COUNT(*) as count FROM `mate-mute` WHERE mutedIdentifier = ?"
	local result = exports.oxmysql:scalarSync(query, { license })
	local count = tonumber(result) or 0
	local isMuted = count > 0

	return isMuted
end

function isAdmin(src, cb)
	if not src then return cb(false) end

	print("CB: ", isAdmin)
	return cb(isAdmin)
end

function showOnlyForAdmins(admins)
	for k, v in ipairs(ESX.GetPlayers()) do
		isAdmin(v, function(data)
			if data then
				admins(v)
			end
		end)
	end
end
