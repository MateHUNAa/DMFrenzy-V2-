ESX = exports['es_extended']:getSharedObject()
-- Variables
local showKillfeed = true
local function SendToKillFeed(id, killer, victim, image, border, background, noScoped, headshot, driveBy, dist, s)
    SendNUIMessage({
        action = "addKillToFeed",
        data = {
            id         = id,
            killer     = killer,
            victim     = victim,
            image      = image,
            border     = border,
            background = background,
            noScoped   = noScoped,
            headshot   = headshot,
            driveBy    = driveBy,
            dist       = dist,
            killstreak = s
        }
    })
end

RegisterNetEvent('killfeed:recivePlayerKillFeed')
AddEventHandler('killfeed:recivePlayerKillFeed', function(killer, victim, image, noScoped, headshot, driveBy, dist, s)
    if not showKillfeed then return end
    local border = 'black-border'
    if killer.netId == PedToNet(PlayerPedId()) then
        border = 'red-border'
    end

    local background = 'black-background'
    if victim.netId == PedToNet(PlayerPedId()) then
        background = 'red-background'
    end

    SendToKillFeed("killed_" .. victim.netId, killer, victim, image, border, background, noScoped, headshot, driveBy,
        dist, s)
end)

-- Initialize --
Citizen.CreateThread(function()
    while not ESX.PlayerData do Wait(150) end

    SendNUIMessage({
        action = "setConfig",
        data = {
            showTime        = Config.ShowTime,
            maxLines        = Config.MaxLines,
            killerColourP   = Config.KillerColour.Player,
            victimColourP   = Config.VictimColour.Player,
            killerColourN   = Config.KillerColour.NPC,
            victimColourN   = Config.VictimColour.NPC,
            joinLeaveColour = Config.JoinLeaveColour,
            killDistColour  = Config.KillDistanceColour
        }
    })
end)
