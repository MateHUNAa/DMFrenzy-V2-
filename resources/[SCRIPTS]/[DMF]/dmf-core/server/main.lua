ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


function GetPlayerData(source)
     local identifier      = GetPlayerIdentifierByType(source, "license")

     local playerData      = {}
     local data            = exports["mate-kd"]:GetStats(identifier)

     local discordData     = mCore.GetDiscordAwait(source)

     local playTime        = MySQL.scalar.await("SELECT playedTime FROM `users` WHERE identifier = ?",
          { identifier:sub(9) }) or 0

     local isVip, Level    = exports["mate-vipsystem"]:GetPlayerVIPLevel(source or identifier)
     --
     playerData.kd         = data or false
     playerData.source     = source
     playerData.identifier = identifier:sub(9)
     playerData.discord    = discordData or false
     playerData.vip        = {
          isVip = isVip or false,
          level = Level or 0
     } or false
     playerData.playedTime = {
          sec     = playTime,
          ms      = playTime * 1000,
          minutes = math.floor(playTime / 60),
          hours   = math.floor((playTime / 60 / 60) * 100) / 100
     } or false

     return playerData
end

exports("GetPlayerData", GetPlayerData)

lib.callback.register('dmf->getPlayerData', (function(source, target)
     local data = GetPlayerData(target or source)
     return data
end))


RegisterNetEvent("dmf-core->SelfDim", (function()
     local source = source

     SetPlayerRoutingBucket(source, source)
     SetRoutingBucketPopulationEnabled(source, false)
     SetRoutingBucketEntityLockdownMode(source, "strict")
end))


RegisterNetEvent('dmf-core->KICK', function(reason)
     -- DropPlayer(source, reason or "No reason provided !")
end)
