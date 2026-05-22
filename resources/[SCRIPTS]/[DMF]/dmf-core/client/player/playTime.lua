local playedHours = 0
Citizen.CreateThread((function()
     while true do
          Wait(60 * 60 * 1000)

          playedHours += 1
          lib.callback.await("dmf-core->SavePlayerTime", false, playedHours)
     end
end))
