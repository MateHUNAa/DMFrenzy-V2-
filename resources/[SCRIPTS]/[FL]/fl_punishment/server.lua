local DISCORD_WEBHOOK = "https://discord.com/api/webhooks/1350487434051453029/9qOuLoeAY_rVsS-BMdcRlHNuYXbTCZmEDIzx-uFJw4tci4pBCFH49avCqfzbezOXK5ko"
local DISCORD_NAME = "DM Frenzy"
local DISCORD_IMAGE = "https://cdn.discordapp.com/attachments/1330202581221507223/1337430636553703444/dmf_logo.png?ex=67a81398&is=67a6c218&hm=241831e22eda413cdd5cd99c24c4b85b694acc89b42a392b8c8c2bfb9a5b2a20&"
local function sendToDiscord(name, message, color)
    adminChatLog(source, message) -- Log message to admin chat
    local connect = {
        {
            ["color"] = color,
            ["title"] = name,
            ["description"] = message,
            ["footer"] = {
                ["text"] = DISCORD_NAME, -- Default footer text
                ["icon_url"] = DISCORD_IMAGE -- Optional footer image
            },
        }
    }

    PerformHttpRequest(DISCORD_WEBHOOK, function(err, text, headers)
        if err ~= 200 then
            print("Discord webhook failed: " .. tostring(err) .. " - " .. tostring(text))
        else
            print("Message successfully sent to Discord.")
        end
    end, 'POST', json.encode({ username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE }), { ['Content-Type'] = 'application/json' })
end

GROUPS_NAME = {
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


local ranks = {
	owner = "Tulajdonos",
	servmanager = "Server Manager",
	dev = "Head Developer",
	subdev = "Developer",
	adminc = "Admin Controller",
    sadmin = "Super Controller",
	cmanager = "Community Manager",
	admin = "Admin",
	helper = "Helper",
}

local adminLogToggledOff = {}

RegisterCommand("toglog", function(source, args, rawCommand)
    adminChatLog(source, rawCommand)

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer then return end

    local playerGroup = xPlayer.getGroup()
    if not GROUPS_NAME[playerGroup] then
		TriggerClientEvent('chat:addMessage', source, {
			template =
				'<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Info]: ^5 Nincs jogosultságod ehhez!</div>'
		})
        return
    end

    if adminLogToggledOff[source] then
        adminLogToggledOff[source] = nil
		TriggerClientEvent('chat:addMessage', source, {
			template =
				'<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Info]: ^2 Admin logok bekapcsolva!</div>'
		})
    else
        adminLogToggledOff[source] = true
		TriggerClientEvent('chat:addMessage', source, {
			template =
				'<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Info]: ^5 Admin logok kikapcsolva!</div>'
		})
    end
end, false)

function adminChatLog(playerSrc, msg)
    if not playerSrc or adminLogToggledOff[playerSrc] then return end
    playerSrc = tonumber(playerSrc)
    local xPlayer = ESX.GetPlayerFromId(playerSrc)

    if not xPlayer then return end

    local playerName = GetPlayerName(playerSrc)
    local allPlayers = ESX.GetExtendedPlayers()

    if not allPlayers or #allPlayers == 0 then return end

    local command = msg and msg:gsub("%s*%d+", "") or "unknown command"
    local rankName = ranks[xPlayer.getGroup()] or "Unknown Rank"

    for _, adminPlayer in pairs(allPlayers) do
        if GROUPS_NAME[adminPlayer.getGroup()] and not adminLogToggledOff[adminPlayer.source] then
            TriggerClientEvent('chat:addMessage', adminPlayer.source, {
                template =
                    '<div style="padding: 0.5vw; margin: 0.5vw; background-color: rgba(0, 0, 0, 0.6); border-radius: 3px;">^1[Admin Log]: ^5(' ..
                    rankName .. ')^9 ' .. playerName .. '^7 használta a ^1' .. command .. '^7 parancsot.</div>'
            })
        end
    end
end


local DAY_SECONDS = 60 * 60 * 24

local function createSQLColumn(name)
	local p = promise.new()

	local exists = MySQL.scalar.await("SHOW COLUMNS FROM `users` LIKE '" .. name .. "'")
	if exists then
		return p:resolve(false)
	end

	MySQL.query(
		([[
			ALTER TABLE `users`
			ADD COLUMN %s TEXT NULL DEFAULT "";
		]]):format(name),
		function()
			Citizen.Trace(("[INFO]: New SQL column created. Name: %s\n"):format(name))
			p:resolve(true)
		end
	)

	return p
end

local function loadPlayerPunishment(player, xPlayer)
	local result = MySQL.single.await("SELECT comserv, jail FROM users WHERE identifier = ?", { xPlayer.identifier })

	for key, row in pairs(result) do
		if type(row) == "string" and (row or ""):len() > 0 then
			row = json.decode(row)
			TriggerClientEvent("updatePlayerPunishment", player, key, row)
			return
		end
	end

	TriggerClientEvent("updatePlayerPunishment", player, "clear")
end
AddEventHandler("esx:playerLoaded", loadPlayerPunishment)

local function sendToDiscord(title, message, color)
	if not WEBHOOK or WEBHOOK:len() <= 0 then
		return
	end

	local embeds = {
		{
			["color"] = color,
			["title"] = "**" .. title .. "**\n",
			["description"] = message,
			["footer"] = {
				["text"] = "fl_punishment by FiveM Land",
			},
		},
	}

	PerformHttpRequest(
		WEBHOOK,
		function() end,
		"POST",
		json.encode({ embeds = embeds }),
		{ ["Content-Type"] = "application/json" }
	)
end

CreateThread(function()
	Citizen.Await(createSQLColumn("comserv"))
	Citizen.Await(createSQLColumn("jail"))
	Citizen.Await(createSQLColumn("ban"))

	for _, player in pairs(GetPlayers()) do
		local xPlayer = ESX.GetPlayerFromId(player)
		if xPlayer then
			loadPlayerPunishment(player, xPlayer)
		end
	end
end)

function getPlayerPunishment(xPlayer, name)
	if not (name == "comserv" or name == "jail") then
		return false
	end

	if type(xPlayer) ~= "table" then
		xPlayer = ESX.GetPlayerFromId(xPlayer)
	end

	local result = MySQL.scalar.await("SELECT ?? FROM users WHERE identifier = ?", { name, xPlayer.identifier })
	if type(result) ~= "string" or (result or ""):len() <= 0 then
		return false
	end

	return json.decode(result)
end
exports("getPlayerPunishment", getPlayerPunishment)

function getPunishmentUsers(selectedTab)
	local result = MySQL.query.await(
		"SELECT identifier, firstname, lastname, ?? FROM users WHERE NOT (?? = '' OR ?? = 'null')",
		{ selectedTab, selectedTab, selectedTab }
	)

	local newResult = {}

	for _, row in pairs(result) do
		row[selectedTab] = json.decode(row[selectedTab])
		row.name = row.firstname .. " " .. row.lastname
		table.insert(newResult, row)
	end

	return newResult
end

ESX.RegisterServerCallback("requestPlayerPunishment", function(player, cb, name)
	cb(getPlayerPunishment(player, name))
end)

ESX.RegisterServerCallback("decreaseComservCount", function(player, cb)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return cb(false)
	end
	local comserv = getPlayerPunishment(xPlayer, "comserv")
	if not comserv then
		return cb(false)
	end

	comserv.count = (comserv.count or comserv.all or 0) - 1
	if comserv.count <= 0 then
		comserv = nil
		if COMSERV.outCoords.Enable then
			xPlayer.setCoords(COMSERV.outCoords.Coords)
		end
	end

	MySQL.query("UPDATE users SET comserv = ? WHERE identifier = ?", {
		json.encode(comserv),
		xPlayer.identifier,
	})

	cb(comserv)
end)

ESX.RegisterServerCallback("increaseAdminJailTime", function(player, cb)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer then
		return cb(false)
	end

	local jail = getPlayerPunishment(xPlayer, "jail")
	if not jail then
		return cb(false)
	end

	jail.count = (jail.count or 0) + 1
	if jail.count >= (jail.all or 0) then
		jail = nil

		output(Translate("adminjail_over"), player)
	end

	MySQL.query("UPDATE users SET jail = ? WHERE identifier = ?", {
		json.encode(jail),
		xPlayer.identifier,
	})

	cb(jail)
end)

ESX.RegisterServerCallback("requestPunishmentUsers", function(player, cb, selectedTab)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not ADMIN_RANKS[xPlayer.getGroup()] then
		return cb(false)
	end

	cb(getPunishmentUsers(selectedTab))
end)

ESX.RegisterServerCallback("removeUserFromPunishment", function(player, cb, selectedTab, identifier)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not ADMIN_RANKS[xPlayer.getGroup()] then
		return cb(false)
	end

	MySQL.query.await("UPDATE users SET	?? = '' WHERE identifier = ?", { selectedTab, identifier })

	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	if xTarget then
		if selectedTab == "comserv" then
			TriggerClientEvent("updatePlayerPunishment", xTarget.source, "comserv", false)
		elseif selectedTab == "jail" then
			TriggerClientEvent("updatePlayerPunishment", xTarget.source, "jail", false)
		end
	end

	output(Translate("removed_punishment"), player)

	cb(getPunishmentUsers(selectedTab))
end)

ESX.RegisterServerCallback("requestPunishmentUserData", function(player, cb, selectedTab, identifier)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not ADMIN_RANKS[xPlayer.getGroup()] then
		return cb(Translate("not_admin"))
	end

	local result = MySQL.query.await(
		"SELECT identifier, firstname, lastname, accounts, job, ?? FROM users WHERE identifier = ?",
		{ selectedTab, identifier }
	)

	if not result or #result <= 0 then
		return cb(Translate("user_not_found"))
	end

	cb(false, result[1])
end)

RegisterCommand("punishments", function(player)
	if not isAdmin(player) then
		return
	end

	TriggerClientEvent("togglePunishmentsAdmin", player)
end, false)

RegisterCommand("közmunka", function(source, args)
    local rawCommand = "közmunka"
    adminChatLog(source, rawCommand) -- Logolja a parancsot az admin chatben
    sendToDiscord("közmunka", GetPlayerName(source) .. " Az admin használta a következő parancsot: **" .. rawCommand .. "** | " .. os.date("Dátum: %x idő: %X"), color)

    local xPlayer = ESX.GetPlayerFromId(source)
    if not isAdmin(xPlayer) then
        return
    end

    if #args < 3 then
        return output(Translate("invalid_syntax"), source)
    end

    local targetId = tonumber(args[1])
    if not targetId then
        return output(Translate("user_not_found"), source)
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        return output(Translate("user_not_found"), source)
    end

    local count = tonumber(args[2])
    if not count or count <= 0 then
        return output(Translate("count_invalid"), source)
    end
    count = math.abs(math.floor(count))

    table.remove(args, 1)
    table.remove(args, 1)
    local reason = table.concat(args, " ")

    if getPlayerPunishment(xTarget, "jail") then
        return output(Translate("player_in_jail"), source)
    end

    if getPlayerPunishment(xTarget, "comserv") then
        return output(Translate("player_in_comserv"), source)
    end

    local adminName = GetPlayerName(source)
    local comserv = {
        count = count,
        all = count,
        reason = reason,
        start = os.time(os.date("!*t")),
        admin = {
            name = adminName,
            identifier = xPlayer.identifier,
        },
    }

    MySQL.insert("UPDATE users SET comserv = ? WHERE identifier = ?", { json.encode(comserv), xTarget.identifier })
    TriggerClientEvent("updatePlayerPunishment", xTarget.source, "comserv", comserv)

    output(Translate("work_allocated", reason), source)
    output(Translate("assigned_you", adminName, count), xTarget.source)
    output(Translate("reason", reason), xTarget.source)

    sendToDiscord(
        "comserv",
        Translate("comserv_log", adminName, GetPlayerName(xTarget.source), xTarget.getName(), count, reason),
        15105570
    )
end, false)

RegisterCommand("közmunkaki", function(source, args)
    local rawCommand = "közmunkaki"
    adminChatLog(source, rawCommand) -- Logolja a parancsot az admin chatben
    sendToDiscord("közmunkaki", GetPlayerName(source) .. " Az admin használta a következő parancsot: **" .. rawCommand .. "** | " .. os.date("Dátum: %x idő: %X"), color)

    local xPlayer = ESX.GetPlayerFromId(source)
    if not isAdmin(xPlayer) then
        return
    end

    if #args < 1 then
        return output(Translate("invalid_syntax"), source)
    end

    local targetId = tonumber(args[1])
    if not targetId then
        return output(Translate("user_not_found"), source)
    end

    local xTarget = ESX.GetPlayerFromId(targetId)
    if not xTarget then
        return output(Translate("user_not_found"), source)
    end

    local comserv = getPlayerPunishment(xTarget, "comserv")
    if not comserv then
        return output(Translate("player_not_in_comserv"), source)
    end

    exports.oxmysql:update("UPDATE users SET comserv = '' WHERE identifier = ?", { xTarget.identifier })
    TriggerClientEvent("updatePlayerPunishment", xTarget.source, "comserv", false)

    local adminName = GetPlayerName(source)

    output(Translate("removed_from_comserv"), source)
    output(Translate("removed_you_comserv", adminName), xTarget.source)

    sendToDiscord(
        "removecomserv",
        Translate("removecomserv_log", adminName, GetPlayerName(xTarget.source), xTarget.getName()),
        15105570
    )
end, false)


function banPlayer(admin, target, days, reason)
	admin = (type(admin) == "number" or type(admin) == "string") and ESX.GetPlayerFromId(admin) or admin
	target = (type(target) == "number" or type(target) == "string") and ESX.GetPlayerFromId(target) or target

	if not isAdmin(admin) then
		Citizen.Trace(("%s (%s) try ban player %s\n"):format(admin.getName(), admin.identifier, target.getName()))
		return false
	end

	local currentTimestamp = os.time(os.date("!*t"))
	local adminName = GetPlayerName(admin.source)
	local ban = {
		count = days,
		start = currentTimestamp,
		endDate = currentTimestamp + ((days == 0 and 3650 or days) * DAY_SECONDS),
		reason = reason,
		admin = {
			name = adminName,
			identifier = admin.identifier,
		},
	}

	sendToDiscord(
		"ban",
		Translate(
			"ban_log",
			adminName,
			GetPlayerName(target.source),
			target.getName(),
			target.identifier,
			days == 0 and "Infinity" or days,
			reason
		),
		15105570
	)

	MySQL.query("UPDATE users SET ban = ? WHERE identifier = ?", { json.encode(ban), target.identifier })

	Wait(1000)
	DropPlayer(target.source, Translate("ban_message", adminName, days == 0 and Translate("infinity") or days, reason))

	return true
end
exports("banPlayer", banPlayer)

RegisterCommand("ban", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not isAdmin(xPlayer) then
		return
	end

	if #args < 2 then
		return output(Translate("invalid_syntax"), player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1])
	if not xTarget then
		return output(Translate("user_not_found"), player)
	end

	local days = tonumber(args[2])
	if not days or days < 0 then
		return output(Translate("invalid_days"), player)
	end
	days = math.floor(days)

	table.remove(args, 1)
	table.remove(args, 1)

	local reason = table.concat(args, " ")
	if reason:len() <= 0 then
		reason = Translate("no_reason")
	end

	local targetCharName = xTarget.getName()

	banPlayer(xPlayer, xTarget, days, reason)

	output(Translate("you_banned", targetCharName), player)
	output(Translate("days", days == 0 and Translate("infinity") or days), player)
	output(Translate("reason", reason), player)
end)

AddEventHandler("playerConnecting", function(name, setKickReason, deferrals)
	local player = source
	local identifiers = GetPlayerIdentifiers(player)
	local selectedId = false

	deferrals.defer()
	Wait(0)

	for _, id in pairs(identifiers) do
		if id:find("license:") then
			selectedId = id:gsub("license:", "")
			break
		end
	end

	deferrals.update(Translate("checking_ban"))

	local banQuery =
		MySQL.query.await("SELECT ban FROM users WHERE SUBSTRING_INDEX(identifier, ':', -1) = ?", { selectedId })

	if not banQuery or #banQuery <= 0 then
		return deferrals.done()
	end

	-- Fix multicharacter ban check
	local result = nil
	for _, row in pairs(banQuery) do
		if row.ban and row.ban ~= "" then
			result = row.ban
			break
		end
	end

	if not result then
		return deferrals.done()
	end

	result = json.decode(result)

	local currentTimestamp = os.time(os.date("!*t"))

	if result.endDate > currentTimestamp then
		return deferrals.done(
			Translate(
				"you_banned_from_server",
				result.admin.name,
				(result.count == 0 and Translate("infinity") or result.count),
				os.date("%Y-%b-%d", result.endDate),
				result.reason,
				selectedId
			)
		)
	else
		Wait(1000)

		deferrals.update(Translate("ban_clear"))

		exports.oxmysql:update("UPDATE users SET ban = '' WHERE identifier = ?", { selectedId })
	end

	Wait(1000)
	deferrals.done()
end)

RegisterCommand("unban", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not isAdmin(xPlayer) then
		return
	end

	if #args < 1 then
		return output(Translate("invalid_syntax"), player)
	end

	local input = table.concat(args, " ")

	local result = MySQL.query.await(
		"SELECT identifier, firstname, lastname, ban FROM users WHERE identifier = ? OR LOWER(CONCAT(firstname, ' ', lastname)) = ?",
		{ input, input }
	)

	if not result or #result < 1 then
		return output(Translate("user_not_found"), player)
	end

	result = result[1]

	if result.ban:len() <= 0 then
		return output(Translate("player_not_banned"), player)
	end

	exports.oxmysql:update("UPDATE users SET ban = '' WHERE identifier = ?", { result.identifier })

	local charName = result.firstname .. " " .. result.lastname

	output(Translate("player_unbanned", charName), player)

	sendToDiscord("unban", Translate("unban_log", GetPlayerName(player), charName, result.identifier), 15105570)
end, false)

RegisterCommand("adminjail", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not isAdmin(xPlayer) then
		return
	end

	if #args < 2 then
		return output(Translate("invalid_syntax"), player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1])
	if not xTarget then
		return output(Translate("user_not_found"), player)
	end

	if getPlayerPunishment(xTarget, "comserv") then
		return output(Translate("player_in_comserv"), player)
	end

	if getPlayerPunishment(xTarget, "jail") then
		return output(Translate("player_in_jail"), player)
	end

	local time = tonumber(args[2])
	if not time then
		return output(Translate("time_not_number"), player)
	end
	time = math.abs(math.floor(time))

	table.remove(args, 1)
	table.remove(args, 1)

	local reason = table.concat(args, " ")
	local adminName = GetPlayerName(player)
	local currentTimestamp = os.time(os.date("!*t"))
	local jail = {
		count = 0,
		start = currentTimestamp,
		all = time,
		reason = reason,
		admin = {
			name = adminName,
			identifier = xPlayer.identifier,
		},
	}

	exports.oxmysql:update("UPDATE users SET jail = ? WHERE identifier = ?", { json.encode(jail), xTarget.identifier })

	TriggerClientEvent("updatePlayerPunishment", xTarget.source, "jail", jail)

	output(Translate("jail_allocated", reason), player)

	output(Translate("jail_assigned", adminName, time), xTarget.source)
	output(Translate("reason", reason), xTarget.source)

	sendToDiscord(
		"adminjail",
		Translate("adminjail_log", adminName, GetPlayerName(xTarget.source), xTarget.getName(), time, reason),
		15105570
	)
end, false)

RegisterCommand("unjail", function(player, args)
	local xPlayer = ESX.GetPlayerFromId(player)
	if not xPlayer or not isAdmin(xPlayer) then
		return
	end

	if #args < 1 then
		return output(Translate("invalid_syntax"), player)
	end

	local xTarget = ESX.GetPlayerFromId(args[1])
	if not xTarget then
		return output(Translate("user_not_found"))
	end

	if not getPlayerPunishment(xTarget, "jail") then
		return output(Translate("player_not_in_jail"), player)
	end

	local adminName = GetPlayerName(player)

	exports.oxmysql:update("UPDATE users SET jail = '' WHERE identifier = ?", { xTarget.identifier })
	TriggerClientEvent("updatePlayerPunishment", xTarget.source, "jail", false)

	output(Translate("you_remove_jail"), player)
	output(Translate("removed_from_jail", adminName), xTarget.source)

	sendToDiscord(
		"unjail",
		Translate("unjail_log", adminName, GetPlayerName(xTarget.source), xTarget.getName()),
		15105570
	)
end)
