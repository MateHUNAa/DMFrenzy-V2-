--
-- Delete Vehicle [G]
--

function DeleteCurrentVehicle()
     if IsPedInAnyVehicle(cache.ped, false) then
          local myVeh = GetVehiclePedIsIn(cache.ped, false)
          local model = GetEntityModel(myVeh)
          local displayname = GetDisplayNameFromVehicleModel(model)
          if DoesEntityExist(myVeh) then
               DeleteEntity(myVeh)

               lib.callback.await("dmf-core->[G]Vehicle", false, model, displayname)
          end
     end
end

RegisterCommand("dmf:removeVehicle", DeleteCurrentVehicle, false)
RegisterKeyMapping("dmf:removeVehicle", "Remove the current vehicle the palyer is seated in !", "keyboard", "G")

--
-- Disable Radio controlls
--

AddEventHandler('esx:enteredVehicle', function(vehicle)
     SetUserRadioControlEnabled(false)

     if GetPlayerRadioStationName() ~= nil then
          SetVehRadioStation(vehicle, "OFF")
     end

     SetVehicleTyresCanBurst(vehicle, false)
     SetEntityInvincible(vehicle, true)
end)

--
-- Remove unused vehicles
--

function IsVehicleEmpty(vehicle, seats)
     for i = -1, seats do
          if not IsVehicleSeatFree(vehicle, i) then
               return false
          end
     end
     return true
end

AddEventHandler('esx:exitedVehicle', function(vehicle)
     if not DoesEntityExist(vehicle) then return end

     Citizen.SetTimeout((3 * 1000), function()
          if DoesEntityExist(vehicle) and Vehicle.IsVehicleEmpty(vehicle, seats) then
               DeleteEntity(vehicle)
          end
     end)

end)

local lastvehicle = nil
local createing = false
exports("vehicle", (function(data, slot)
     if not createing then createing = true else return end
     local vehicleModel = slot.metadata.model

     if not vehicleModel then
          print("Corrupted item !")
          return
     end

     if IsPedFatallyInjured(cache.ped) or GetEntityHealth(cache.ped) == 0 then
          return
     end

     if IsPedInAnyVehicle(cache.ped, false) then
          return
     end

     if lastvehicle then
          if DoesEntityExist(lastvehicle) then
               DeleteEntity(lastvehicle)
               lastvehicle = nil
          end
     end

     lib.requestModel(vehicleModel, 1000)

     local succes, data = lib.callback.await("dmf-core->CreateVehicle", false, vehicleModel)

     if not succes then
          return mCore.Notify(lang.Title, "Something went wrong !", "error", 5000)
     end

     lastvehicle = NetworkGetEntityFromNetworkId(data.netId)

     SetModelAsNoLongerNeeded(vehicleModel)
     TaskWarpPedIntoVehicle(cache.ped, lastvehicle, -1)

     createing = false
     Functions.toggleItem(0, slot.name, 1)
end))

lib.callback.register("dmf-core:IsPedSeatedInVehicle", (function()
     local inVehicle = IsPedInAnyVehicle(cache.ped, false)

     if not inVehicle then return false, nil end
     local veh = GetVehiclePedIsIn(cache.ped, false)
     if not NetworkGetEntityIsNetworked(veh) then
          NetworkRegisterEntityAsNetworked(veh)
     end

     local netId = NetworkGetNetworkIdFromEntity(veh)

     return inVehicle, netId
end))
