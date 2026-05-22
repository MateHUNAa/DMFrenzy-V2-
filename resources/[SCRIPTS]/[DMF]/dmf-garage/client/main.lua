ESX           = exports['es_extended']:getSharedObject()
mCore         = exports["mCore"]:getSharedObj()
lang          = Loc[Config.lan]

local lastveh = nil
local loaded  = false
OpenPanel     = (function()
     RegisterContext()
     -- if not loaded then
     --      return mCore.Notify("[DMF Garage]", "You dont have any vehicle", "error", 5000)
     -- end
     lib.showContext("dmf-garage")
end)
RegisterCommand("garage", OpenPanel)
RegisterKeyMapping("garage", "Open's the garage", "keyboard", "F4")


RegisterContext = (function()
     local haveVehicles = true
     local haveFactions = true

     local vehicles = lib.callback.await("dmf-garage->GetOwnedVehicles", false)

     local ops = {}

     if not vehicles or next(vehicles) == nil then
          haveVehicles = false
     end

     if haveVehicles then
          for i = 1, #vehicles do
               local row = vehicles[i]
               local vehicle = json.decode(row.vehicle)

               table.insert(ops, {
                    title = GetDisplayNameFromVehicleModel(vehicle.model),
                    onSelect = (function()
                         if lastveh then
                              if DoesEntityExist(lastveh) then
                                   DeleteEntity(lastveh)
                              end
                         end

                         if IsPedFatallyInjured(cache.ped) or GetEntityHealth(cache.ped) == 0 then
                              return
                         end

                         local success, data = lib.callback.await("dmf-core->CreateVehicle", false, vehicle.model)

                         if not success then
                              return mCore.Notify("[DMF Garage]", "Something went wrong while spawning vehicle !",
                                   "error", 5000)
                         end

                         lastveh = NetworkGetEntityFromNetworkId(data.netId)

                         local to = GetGameTimer() + 5000

                         while not DoesEntityExist(lastveh) do
                              if GetGameTimer() >= to then
                                   break
                              end

                              Wait(255)
                         end

                         if DoesEntityExist(lastveh) then
                              TaskWarpPedIntoVehicle(cache.ped, lastveh, -1)
                         end
                    end)
               })
          end
     end
     local factionVehicles
     if ESX.PlayerData.job.name ~= "unemployed" then
          factionVehicles = exports["dmf-factions"]:GetGarage(ESX.PlayerData.job.name)
     end

     if not factionVehicles or next(factionVehicles) == nil then
          haveFactions = false
     end
     local opss = {}


     if haveFactions then
          for i, v in pairs(factionVehicles) do
               table.insert(opss, {
                    title = v.Label,
                    onSelect = (function()
                         if lastveh then
                              if DoesEntityExist(lastveh) then
                                   DeleteEntity(lastveh)
                              end
                         end
                         
                         if IsPedFatallyInjured(cache.ped) or GetEntityHealth(cache.ped) == 0 then
                              return
                         end

                         local success, data = lib.callback.await("dmf-core->CreateVehicle", false, v.Value)

                         if not success then
                              return mCore.Notify("[DMF Garage]", "Something went wrong while spawning vehicle !",
                                   "error", 5000)
                         end

                         lastveh = NetworkGetEntityFromNetworkId(data.netId)

                         if DoesEntityExist(lastveh) then
                              TaskWarpPedIntoVehicle(cache.ped, lastveh, -1)
                         end
                    end)
               })
          end
     end

     lib.registerContext({
          id = "dmf-garage",
          title = "DMF Garage",
          options = {
               haveVehicles and {
                    title = "OWNED GARAGE",
                    onSelect = (function()
                         lib.registerContext({
                              id      = "dmf-garage-owned",
                              title   = "OWNED GARAGE",
                              menu    = "dmf-garage",
                              options = ops
                         })

                         lib.showContext("dmf-garage-owned")
                    end)
               } or { title = "OWNED GARARGE" },
               haveFactions and {
                    title = "FRAKCIO GARAGE",
                    onSelect = (function()
                         lib.registerContext({
                              id      = "dmf-garage-fk",
                              menu    = "dmf-garage",
                              title   = "FACTION GARAGE",
                              options = opss
                         })
                         lib.showContext("dmf-garage-fk")
                    end)
               } or { title = "FRAKCIO GARAGE" }
          }
     })
     loaded = true
end)


RegisterCommand("garage:reContext", (function(src, args, raw)
     RegisterContext()
end))

Citizen.CreateThread((function()
     while not ESX.IsPlayerLoaded() do Wait(1000) end

     RegisterContext()
end))

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
     RegisterContext()
end)
