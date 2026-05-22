ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()
lang  = Loc[Config.lan]



RegisterCommand("startcup", (function(src, args, raw)
     local isAdmin = lib.callback.await("mate-admin:cb:isAdmin", false)
     if not isAdmin then return end

     local teamName1 = args[1]
     local teamName2 = args[2]


     if not teamName1 or not teamName2 then
          -- TODO: Refer for correct usage.
          return print("teamName1 or teamName2 args is not found !")
     end

     if teamName1:len() <= 0 or teamName2:len() <= 0 then
          return print("teamName1 or teamName2 is too short for a being a valid teamName !")
     end


     TriggerServerEvent("dmf-cup->InitiateCup", {
          team1 = teamName1,
          team2 = teamName2
     })
     --
end))

RegisterCommand("cupgamestart", (function(src, args, raw)
     local isAdmin = lib.callback.await("mate-admin:cb:isAdmin", false)
     if not isAdmin then return end

     local teamName1 = args[1]
     local teamName2 = args[2]


     if not teamName1 or not teamName2 then
          -- TODO: Refer for correct usage.
          return print("teamName1 or teamName2 args is not found !")
     end

     if teamName1:len() <= 0 or teamName2:len() <= 0 then
          return print("teamName1 or teamName2 is too short for a being a valid teamName !")
     end

     TriggerServerEvent('dmf-cup:StartGame', {
          team1 = teamName1,
          team2 = teamName2
     })
end))

lib.callback.register("dmf-cup->SetInvicibility", (function(toggle)
     SetEntityInvincible(cache.ped, toggle)
end))

RegisterNetEvent('dmf-cup->END', function()
     Wait(700)

     exports["dmf-mainmenu"]:Open()
end)

RegisterNetEvent('dmf-cup->Countdown', function()
     local asd = true
     local last = GetGameTimer()
     local sec = 5
     Citizen.CreateThread((function()
          while asd do
               Draw2DText(tostring(sec))
               Wait(1)

               if last + 1000 <= GetGameTimer() then
                    last = GetGameTimer()
                    sec -= 1
               end
          end
     end))
     Wait(5000)
     asd = false
end)

function Draw2DText(text)
     SetTextFont(font)
     SetTextScale(0.5, 0.5)
     SetTextColour(255, 165, 0, 150)
     SetTextOutline()
     SetTextCentre(true)

     BeginTextCommandDisplayText("STRING")
     AddTextComponentSubstringPlayerName(text)
     EndTextCommandDisplayText(.5, .05)
end
