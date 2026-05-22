ESX          = exports['es_extended']:getSharedObject()
mCore        = exports["mCore"]:getSharedObj()

local blip   = nil
local bounty = false

RegisterNetEvent("dmf-bounty:StartBounty", (function(serverId)
     print("Staring Bounty...")
     bounty = true

     if blip and DoesBlipExist(blip) then
          RemoveBlip(blip)
     end

     local player = GetPlayerFromServerId(serverId)

     if player == -1 then
          return print("Bounty player not found !")
     end

     local bountyPed = GetPlayerPed(player)

     Citizen.CreateThread((function()
          while bounty do
               if blip and DoesBlipExist(blip) then
                    RemoveBlip(blip)
               else
                    blip = AddBlipForEntity(bountyPed)
                    SetBlipSprite(blip, 303)
                    SetBlipScale(blip, 0.8)
                    SetBlipColour(blip, 3)
                    SetBlipAsShortRange(blip, true)
                    SetBlipAsFriendly(blip, false)

                    BeginTextCommandSetBlipName('STRING')
                    AddTextComponentString(tostring("Bounty Target"))
                    EndTextCommandSetBlipName(blip)
               end
               Wait(5000)
          end
     end))
end))


RegisterNetEvent('dmf-bounty:RemoveBlip', (function()
     print("removeBlip")
     bounty = false
     Wait(2000)
     if blip and DoesBlipExist(blip) then
          RemoveBlip(blip)
     end
end))

local txd
Citizen.CreateThread((function()
     txd = CreateRuntimeTxd("dmf_bounty")
     CreateRuntimeTextureFromImage(txd, "logo", "icons/dmf.png")
end))

RegisterNetEvent('dmf-bounty:DisplayMessage', function(message, title)
     BeginTextCommandThefeedPost("STRING")
     AddTextComponentSubstringPlayerName(title or "N/A")
     EndTextCommandThefeedPostMessagetext("dmf_bounty", "logo", true, 9, message or "N/A", "")
     EndTextCommandThefeedPostTicker(false, true)
end)
