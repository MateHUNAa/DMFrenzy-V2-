AddEventHandler("esx:setJob", function(job)
     local PlayerData = ESX.GetPlayerData()
     PlayerData.job = job
end)

AddEventHandler("dmf-factions->ToggleAntiTK", (function()
     if ESX.PlayerData.job.name == 'unemployed' then
          TKState = false
          return
     end

     TKState = not TKState

     if TKState then
          local playerPed = PlayerPedId()
          local group = "frakcio" .. ESX.PlayerData.job.name
          local _, hash = AddRelationshipGroup(group)
          local myhash = hash
          SetPedRelationshipGroupHash(playerPed, myhash)
          SetEntityCanBeDamagedByRelationshipGroup(playerPed, false, myhash)
          mCore.Notify("[DMF Factions]", "Anti TK enabled", "info", 5000)
     else
          local playerPed = PlayerPedId()
          SetPedRelationshipGroupHash(playerPed, "PLAYER")
          SetEntityCanBeDamagedByRelationshipGroup(playerPed, true, "PLAYER")
          mCore.Notify("[DMF Factions]", "Anti TK disabled", "info", 5000)
     end
end))


Citizen.CreateThread(function()
     Citizen.Wait(1000)
     while true do
          if tkswitch then
               if ESX.PlayerData.job.name == 'unemployed' then
                    local playerPed = PlayerPedId()
                    SetPedRelationshipGroupHash(playerPed, "PLAYER")
                    SetEntityCanBeDamagedByRelationshipGroup(playerPed, true, "PLAYER")
               else
                    local playerPed = PlayerPedId()
                    local group = "frakcio" .. ESX.PlayerData.job.name
                    local _, hash = AddRelationshipGroup(group)
                    local myhash = hash
                    SetPedRelationshipGroupHash(playerPed, myhash)
                    SetEntityCanBeDamagedByRelationshipGroup(playerPed, false, myhash)
               end
          end

          Citizen.Wait(10000)
     end
end)
