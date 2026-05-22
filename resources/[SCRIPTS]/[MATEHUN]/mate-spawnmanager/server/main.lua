ESX                   = exports['es_extended']:getSharedObject()

local respawnRequests = {}

local function DeathState(pid, state)
     if not pid or not state then return end

     if type(state) ~= "boolean" then return end

     Player(pid).state:set("isDead", state, true)
end

RegisterNetEvent('dmf-spawnmanager->setDeathStatus', function(newStatus)
     local xPlayer = ESX.GetPlayerFromId(source)
     local idf     = xPlayer.getIdentifier()

     if type(newStatus) ~= "boolean" then return end

     MySQL.update("UPDATE `users` SET is_dead = ? WHERE identifier = ?", { newStatus, idf })
     DeathState(xPlayer.source, newStatus)
end)

RegisterNetEvent('dmf-spawnmanager->RemoveItems', function(keep)
     local xPlayer = ESX.GetPlayerFromId(source)

     local inventory = exports["ox_inventory"]:GetInventoryItems(xPlayer.source)

     exports["ox_inventory"]:ClearInventory(xPlayer.source, keep)

     -- mCore.sendMessage(json.encode(inventory), Config.Webhooks["removedItems"], "mhScripts, SpawnManager")
end)

RegisterNetEvent('dmf-spawnmanager->revive', function(target)
     if not target then return end

     local state = Player(target).state
     if not state["isDead"] then return end

     TriggerClientEvent('dmf-spawnmanager->revive', target)

     DeathState(target, false)
end)

RegisterNetEvent('esx:onPlayerDeath', function(data)
     DeathState(source, true)
end)

RegisterNetEvent('esx:onPlayerSpawn', (function()
     DeathState(source, false)
end))


RegisterNetEvent('dmf-spawnmanager->sendRequest', function(target)
     if not target then return end
     local source = source

     local ped = GetPlayerPed(source)
     if not IsPedDeadOrDying(ped, true) then
          -- mCore.Notify(source, "[SpawnManager]", "This player is not dead/dying !", "error", 4999)
          return
     end

     if respawnRequests[source] and GetGameTimer() - respawnRequests[source] < 5000 then
          -- mCore.Notify(source, "[Spawnmanager]", "Please slow down", "info", 4999)
          return
     end

     local accepted, error = lib.callback.await("dmf-spawnmanager->askForRevive", target)
     if error then
          -- mCore.Notify(source, "[SpawnManager]", "Something went wrong while asking for revive !", "error", 4999)
          return
     end

     respawnRequests[source] = GetGameTimer()
     if not accepted then
          -- mCore.Notify(source, "[SpawnManager]", "This player declined your request !", "info", 4999)
          return
     end

     -- Start revive !
     TriggerClientEvent('dmf-spawnmanager->StartReviveAnim', source, target)
end)

--
-- Callbacks
--

lib.callback.register("dmf-spawnmanager->getDeathStatus", (function(source)
     local xPlayer = ESX.GetPlayerFromId(source)
     local idf = xPlayer.getIdentifier()
     local resp = MySQL.scalar.await('SELECT is_dead FROM `users` WHERE identifier = ?', { idf })
     return resp
end))
