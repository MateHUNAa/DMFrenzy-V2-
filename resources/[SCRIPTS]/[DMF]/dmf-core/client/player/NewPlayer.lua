local newPlayer = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
     if isNew then
          Wait(1500)
          TriggerEvent("esx_skin:resetFirstSpawn")
          TriggerEvent("dmf-initChar")
          -- TriggerEvent("esx_skin:playerRegistered")
     end
     TriggerServerEvent('dmf-core->SelfDim')
end)

return newPlayer
