mCore = exports["mCore"]:getSharedObj()
ESX = exports['es_extended']:getSharedObject()

local InSafezone = false

exports("IsPlayerInSafeZone", (function()
     return InSafezone
end))

lib.callback.register("dmf->IsPlayerInSafeZone", (function()
     return InSafezone
end))

local zones = {}
local currentRules = {}

RegisterNetEvent("mate-dimManager->Update", (function(data)
     currentRules = data.rules
end))

Citizen.CreateThread(function()
     while not ESX.PlayerData do Wait(150) end
     for name, v in pairs(Config.Zones) do
          zones[#zones + 1] = lib.zones.box({
               coords   = vec3(v.x, v.y, v.z),
               size     = v.size,
               debug    = false,
               rotation = v.heading,


               onEnter = (function()
                    InSafezone = true
                    SetLocalPlayerAsGhost(true)
               end),

               onExit = (function()
                    InSafezone = false
                    if currentRules["GhostVehicle"] then
                         if IsPedInAnyVehicle(cache.ped, false) then
                              return
                         end
                    end
                    SetLocalPlayerAsGhost(false)

                    Citizen.Wait(600)
                    if v.speedBuff then
                         giveSpeed(cache.ped)
                    end
               end),

               inside = function(self)
                    SetLocalPlayerAsGhost(true)
               end
          })
     end
end)

function giveSpeed(ped)
     local timer = GetGameTimer()

     while timer ~= nil do
          local elapsedTime = GetGameTimer() - timer

          SetPedMoveRateOverride(ped, 1.4)
          SetRunSprintMultiplierForPlayer(ped, 1.4)
          if elapsedTime >= 5000 then
               timer = nil
               SetPedMoveRateOverride(ped, 1.0)
               SetRunSprintMultiplierForPlayer(ped, 1.0)
          end

          Citizen.Wait(0)
     end
end
