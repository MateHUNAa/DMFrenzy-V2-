ESX         = exports['es_extended']:getSharedObject()
mCore       = exports["mCore"]:getSharedObj()
lang        = Loc[Config.lan]

local debug = false
exports('getDebug', function()
     return debug
end)

while true do
     Wait(0)
     if NetworkIsSessionStarted() then
          break
     end
     if debug then
          print("Waiting for player session !")
     end
end

while not ESX.IsPlayerLoaded() do Wait(200) end
Wait(1500)

local Settings = Config.DefaultSettings

Citizen.CreateThread((function()
     while true do
          if Settings["InfinitAmmo"] then
               _ReloadPedWeapon()
          end

          if Settings['NoRecoil'] then
               _NoRecoil()
          end

          if Settings["NoRagdoll"] then
               _NoRagdoll()
          end

          if Settings["Parachute"] then
               _Parachute()
          end

          Wait(500)
     end
end))


RegisterNetEvent('dmf-core->UpdateSettings', function(newSettings)
     Settings = newSettings
end)

RegisterCommand("dmf:debug", (function()
     debug = not debug
     TriggerEvent("dmf-core->debugChanged", debug)
     TriggerServerEvent("dmf-core->debugChanged", debug)
end))
