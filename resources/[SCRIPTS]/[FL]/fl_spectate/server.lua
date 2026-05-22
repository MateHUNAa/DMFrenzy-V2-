ESX = exports['es_extended']:getSharedObject()

local DISCORD_WEBHOOK =
"https://discord.com/api/webhooks/1337431122564612106/DbXZHeSX_Ygihv82fcyi3Diu9JjAEw03S_NKTCqmtQECzGr_G3EFie-zizwrQNXvnsPe"
local DISCORD_NAME = "DM Frenzy"
local DISCORD_IMAGE =
"https://cdn.discordapp.com/attachments/1330202581221507223/1337430636553703444/dmf_logo.png?ex=67a81398&is=67a6c218&hm=241831e22eda413cdd5cd99c24c4b85b694acc89b42a392b8c8c2bfb9a5b2a20&"
local function sendToDiscord(name, message, color)
    adminChatLog(source, message) -- Log message to admin chat
    local connect = {
        {
            ["color"] = color,
            ["title"] = name,
            ["description"] = message,
            ["footer"] = {
                ["text"] = DISCORD_NAME,     -- Default footer text
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
        end, 'POST', json.encode({ username = DISCORD_NAME, embeds = connect, avatar_url = DISCORD_IMAGE }),
        { ['Content-Type'] = 'application/json' })
end


GROUPS_NAME = exports["mate-admin"]:getAdminGroups()


local fullGroups = exports["mate-admin"]:getFullAdminGroups()

local ranks = {

}
for i, v in pairs(fullGroups) do
    ranks[i] = v.tag
end


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

function getPlayerList()
    local players = {}
    for _, serverId in pairs(GetPlayers()) do
        local xPlayer = ESX.GetPlayerFromId(serverId)
        if xPlayer then
            local job = xPlayer.getJob()
            local jobText = job.label .. " - " .. job.grade_label

            table.insert(players, {
                serverId = serverId,
                name = xPlayer.getName() .. " (" .. GetPlayerName(serverId) .. ")",
                group = xPlayer.getGroup(),
                jobText = jobText,
            })
        end
    end

    return players
end

ESX.RegisterServerCallback("requestServerPlayers", function(source, cb)
    local xSource = ESX.GetPlayerFromId(source)

    if not xSource or not ALLOWED_GROUPS[xSource.getGroup()] then
        return cb(false)
    end

    cb(getPlayerList())
end)

ESX.RegisterServerCallback("requestPlayerCoords", function(source, cb, serverId)
    local xSource = ESX.GetPlayerFromId(source)

    if not xSource then
        return cb(false)
    end

    local targetPed = GetPlayerPed(serverId)
    if targetPed <= 0 or not ALLOWED_GROUPS[xSource.getGroup()] then
        return cb(false)
    end

    cb(GetEntityCoords(targetPed))
end)

ESX.RegisterServerCallback("kickPlayerSpectate", function(source, cb, target, reason)
    local xSource = ESX.GetPlayerFromId(source)
    if not xSource or not ALLOWED_GROUPS[xSource.getGroup()] then
        return
    end

    DropPlayer(target, ("Kicked from the server.\nReason: %s\nAdmin: %s"):format(GetPlayerName(source), reason))

    cb(getPlayerList())
end)

RegisterCommand("spectate", function(source)
    local rawCommand = "spectate"
    adminChatLog(source, rawCommand) -- Logolja a parancsot az admin chatben
    sendToDiscord("spectate",
        GetPlayerName(source) ..
        " Az admin használta a következő parancsot: **" .. rawCommand .. "** | " .. os.date("Dátum: %x idő: %X"), color)

    local xPlayer = ESX.GetPlayerFromId(source)
    if not xPlayer or not ALLOWED_GROUPS[xPlayer.getGroup()] then
        return
    end

    TriggerClientEvent("openSpectateMenu", source, getPlayerList())
end, false)
