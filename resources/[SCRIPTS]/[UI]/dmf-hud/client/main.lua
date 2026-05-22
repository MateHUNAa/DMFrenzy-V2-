ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()
lang  = Loc[Config.lan]


local playerId    = GetPlayerServerId(PlayerId())
local visible     = true
local clientState = false


RegisterNetEvent("mate-dimManager->Update", (function(data)
     if not data or type(data) == "nil" then return end

     SendNUIMessage({
          action = "updateUserStats",
          data = {
               gamemode          = data.gm,
               id                = playerId,
               playersInGamemode = data.playerCount
          }
     })
end))


Citizen.CreateThread((function()
     Wait(500)
     TriggerServerEvent("mate-dimManager->RequestUpdate")
end))

local toggleVisibility = (function()
     visible = not visible
     SendNUIMessage({
          action = "toggleVisibility",
          data = visible
     })
end)

exports("toggle", (function()
     toggleVisibility()
end))

RegisterNetEvent('dmf->HideHUD', function()
     visible = false
     SendNUIMessage({
          action = "toggleVisibility",
          data = visible
     })
end)

RegisterNetEvent('dmf->ShowHUD', function()
     visible = true
     if clientState == false then
          visible = false
     end
     SendNUIMessage({
          action = "toggleVisibility",
          data = visible
     })
end)

RegisterCommand("toghud", (function(src, args, raw)
     toggleVisibility()
     Wait(345)
     clientState = not clientState
end))


local lastUpdate = GetGameTimer()
Citizen.CreateThread((function()
     while true do
          Wait(visible and 800 or 2000)

          local ks = exports["mate-kd"]:getKS()
          Wait(1)
          SendNUIMessage({
               action = "refreshStats",
               data = {
                    health = GetEntityHealth(cache.ped) - 100,
                    shield = GetPedArmour(cache.ped),
                    ks     = ks
               }
          })

          if lastUpdate + 5000 <= GetGameTimer() then
               TriggerServerEvent("mate-dimManager->RequestUpdate")
               lastUpdate = GetGameTimer()
          end
     end
end))


-- updateUserStats
