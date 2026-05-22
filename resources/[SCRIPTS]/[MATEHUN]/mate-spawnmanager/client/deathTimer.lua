local Timer = {
     stopped = false,
     isClickReleased = true
}

lib.locale()



function Timer.StartTimer()
     Timer.RespawnTime = math.floor(Config.RespawnTime["Default"])
     Timer.Paused      = false

     SendNUIMessage({
          action = "StartTimer",
          data   = Timer.RespawnTime
     })

     CreateThread((function()
          local lastUpdate = GetGameTimer()

          local minusOnClick = 0.45
          while Timer.RespawnTime > 0 and isDead do
               if Timer.stopped then break end

               Wait(0)
               if not Timer.Paused and Timer.RespawnTime > 0 and (lastUpdate + 1000 <= GetGameTimer()) then
                    lastUpdate = GetGameTimer()
                    Timer.RespawnTime -= 1
                    SendNUIMessage({
                         action = "RemoveTime",
                         data   = 1
                    })
               end

               if IsControlJustReleased(0, 24) then
                    Timer.RespawnTime -= minusOnClick
                    SendNUIMessage({
                         action = "RemoveTime",
                         data   = minusOnClick
                    })
               end
          end
     end))

     CreateThread((function()
          local text

          while Timer.RespawnTime > 0 and isDead do
               -- if Timer.stopped then break end
               -- text = (string.format("Respawn in [%s]", SecToClock(Timer.RespawnTime)))
               -- DrawTextThisFrame(text)
               Wait(250)
          end

          if not Timer.stopped then
               TriggerEvent("dmf-spawnmanager->Revive", GetClosestSpawn(GetEntityCoords(cache.ped)))
          end

          SendNUIMessage({
               action = "setVisibility",
               data   = false
          })

          Timer.stopped = false
     end))
end

function Timer.Pause()
     if isDead and Timer.RespawnTime > 0 then
          Timer.Paused = true
     else
          if Config.debug then
               local invoke = GetInvokingResource() or GetCurrentResourceName()
               print(("[Timer]: Failed to pause timer player is not dead ! [-> %s]"):format(invoke))
          end
     end
end

function Timer.Resume()
     if isDead and Timer.RespawnTime > 0 then
          Timer.Paused = false
     else
          if Config.debug then
               local invoke = GetInvokingResource() or GetCurrentResourceName()
               print(("[Timer]: Failed to pause timer player is not dead ! [-> %s]"):format(invoke))
          end
     end
end

function Timer.Stop()
     if isDead and Timer.RespawnTime and Timer.RespawnTime > 0 or true then
          Timer.stopped     = true
          Timer.RespawnTime = 0
          Timer.Paused      = false
     else
          if Config.debug then
               local invoke = GetInvokingResource() or GetCurrentResourceName()
               print(("[Timer]: Failed to stop timer: Player is not dead ! [-> %s]"):format(invoke))
          end
     end
end

exports("pauseTimer", Timer.Pause)
exports("pause", Timer.Pause)
exports("resume", Timer.Resume)
exports("stop", Timer.Stop)


return Timer
