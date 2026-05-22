local AFK_START_TIME = (5 * 1000) * 60

CreateThread(function()
     while true do
          local diff = GetTimeSinceLastInput(0)
          if diff > AFK_START_TIME then
               TriggerServerEvent('dmf-core->KICK', "AFK !")
          end

          Wait(500)
     end
end)
