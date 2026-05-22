local fkBlips = {}

RegisterNetEvent('dmf-factions:CreateTeammateBlips', function(data)
     for i, v in pairs(data) do
          local player = GetPlayerFromServerId(v.id)
          if player ~= -1 then
               local ped = GetPlayerPed(player)
               if DoesEntityExist(ped) then
                    fkBlips[#fkBlips + 1] = AddBlipForEntity(ped)
                    SetBlipSprite(fkBlips[#fkBlips], 6)
                    SetBlipScale(fkBlips[#fkBlips], .6)
                    SetBlipColour(fkBlips[#fkBlips], 69)
                    SetBlipCategory(fkBlips[#fkBlips], 30)
                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(v.name)
                    EndTextCommandSetBlipName(fkBlips[#fkBlips])
               end
          end
     end
end)

RegisterNetEvent('dmf-factions:removeTeamBlips', function()
     for i = 1, #fkBlips do
          local b = fkBlips[i]
          if DoesBlipExist(b) then
               RemoveBlip(b)
          end
     end
end)


AddEventHandler("onResourceStop", (function(res)
     if GetCurrentResourceName() ~= res then return end

     for i = 1, #fkBlips do
          local b = fkBlips[i]
          if DoesBlipExist(b) then
               RemoveBlip(b)
          end
     end
end))


lib.callback.register("dmf-factions->IsTeamBlipEnabled", (function()
     return BlipState
end))
