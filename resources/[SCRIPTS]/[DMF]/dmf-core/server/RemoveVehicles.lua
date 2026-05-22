local lang = Loc[Config.lan]
Citizen.CreateThread((function()
     while true do
          Wait(Config.Intervals["DeleteVehicles"])
          -- mCore.Notify(-1, mCore.getServerName(), lang.info["vehicles_remove_10"], "info", 5000)
          local VehiclesCannotBeDeleted = {}

          for i, player in pairs(GetPlayers()) do
               local inVehicle, netId = lib.callback.await("dmf-core:IsPedSeatedInVehicle", player, false)
               if inVehicle then
                    table.insert(VehiclesCannotBeDeleted, NetworkGetEntityFromNetworkId(netId))
               end
          end

          local c = 0
          for i, entity in ipairs(GetAllVehicles()) do
               local canDel = true
               for i, v in pairs(VehiclesCannotBeDeleted) do
                    if entity == v then
                         canDel = false
                         break
                    end
               end

               if canDel then
                    DeleteEntity(entity)
                    c += 1
               end
          end

          -- if c >= 1 then
          --      mCore.Notify(-1, mCore.getServerName(), string.format(lang.info["vehicles_deleted"], c), "info", 5000)
          -- end
     end
end))
