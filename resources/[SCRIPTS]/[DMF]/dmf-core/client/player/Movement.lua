local Movement = {}

local crouched = false

Citizen.CreateThread(function()
     local animSet = "move_ped_crouched"

     RequestAnimSet(animSet)
     while not HasAnimSetLoaded(animSet) do
          Citizen.Wait(50)
     end

     print("Crouch anim loaded !")

     while true do
          Citizen.Wait(1)

          local ped = PlayerPedId()
          if not IsEntityDead(ped) then
               DisableControlAction(0, 26, true) -- G gomb (INPUT_DUCK)

               if not HasAnimSetLoaded(animSet) then
                    return print("[FATAL]: Crouch animation set not been loaded !")
               end

               if not IsPauseMenuActive() and IsDisabledControlJustPressed(0, 26) then
                    if crouched then
                         ResetPedMovementClipset(ped, 0.25)
                    else
                         SetPedMovementClipset(ped, animSet, 0.25)
                    end
                    crouched = not crouched
               end
          end
     end
end)


--
-- AntiRagdoll
--

function _NoRagdoll()
     ResetPlayerStamina(PlayerId())
     SetPlayerFallDistance(PlayerId(), 1000.0)
     SetPedCanRagdoll(cache.ped, false)
     SetPedRagdollOnCollision(cache.ped, false)
     SetEntityProofs(cache.ped, false, true, true, false, true, true, false, true)

     if IsPedOnAnyBike(cache.ped) then
          SetPedCanBeKnockedOffVehicle(cache.ped, 1)
     end

     for i = 1, 26 do
          SetRagdollBlockingFlags(cache.ped, i)
     end
end

--
-- Roll >?<
--

for i = 0, 3 do
     StatSetInt(GetHashKey("mp" .. i .. "_shooting_ability"), 110, true)
     StatSetInt(GetHashKey("sp" .. i .. "_shooting_ability"), 110, true)
end
return Movement
