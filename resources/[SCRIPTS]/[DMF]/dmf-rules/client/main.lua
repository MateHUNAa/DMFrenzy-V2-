ESX                      = exports['es_extended']:getSharedObject()
mCore                    = exports["mCore"]:getSharedObj()
lang                     = Loc[Config.lan]

local bucketId, gm, mode = nil, nil, nil
local currentRules       = {}


local isGhost = false
local lastVeh


---@param data { gm: string, mode: string, rules: table, bucket: number }
RegisterNetEvent("mate-dimManager->Update", (function(data)
     if not data or type(data) == "nil" then -- Leaveing gamemode cleanup stage
          if DoesEntityExist(veh) then
               DeleteEntity(veh)
          end

          DisableShooting(false)

          return
     end

     bucketId = data.bucket

     if currentRules["onSpawnGiveVehicle"] and not data.rules["onSpawnGiveVehicle"] then
          DeleteEntity(lastVeh)
     end

     currentRules = data.rules
     gm, mode     = data.gm, data.mode


     if currentRules["DenyVehicles"] then
          Citizen.CreateThread((function()
               while currentRules["DenyVehicles"] do
                    Wait(500)
                    if IsPedInAnyVehicle(cache.ped, false) then
                         local veh = GetVehiclePedIsIn(cache.ped, false)
                         if DoesEntityExist(veh) then
                              DeleteEntity(veh)
                         end
                    end
               end
          end))
     end

     if currentRules["GhostVehicle"] then
          Citizen.CreateThread((function()
               while currentRules["GhostVehicle"] do
                    Wait(500)
                    local myveh = GetVehiclePedIsIn(cache.ped, false)

                    if DoesEntityExist(myveh) then
                         if not isGhost then
                              SetLocalPlayerAsGhost(true)
                              SetNetworkVehicleAsGhost(myveh, true)
                              isGhost = true
                         end
                    else
                         if isGhost then
                              SetLocalPlayerAsGhost(false)
                              isGhost = false
                         end
                    end
               end
               Wait(3000)
               SetLocalPlayerAsGhost(false)
               isGhost = false
          end))
     end

     if currentRules["0kmph"] then
          Wait(1500)

          if DoesEntityExist(lastVeh) then
               DeleteEntity(lastVeh)
          end
          local succes, data = lib.callback.await("dmf-core->CreateVehicle", false,
               tostring(currentRules["onSpawnGiveVehicle"]))

          if not succes then
               return mCore.Notify(lang.Title, "Something went wrong !", "error", 5000)
          end

          lastVeh = NetworkGetEntityFromNetworkId(data.netId)

          SetPedIntoVehicle(cache.ped, lastVeh, -1)

          Citizen.CreateThread((function()
               while currentRules["0kmph"] do
                    Wait(1)


                    local pedVehicle = GetVehiclePedIsIn(cache.ped, false)

                    if (GetEntitySpeed(pedVehicle) > 5) then
                         DisableShooting(true)
                    else
                         DisableShooting(false)
                    end
               end
          end))
     end
end))

--
-- Events
--
AddEventHandler("ox_inventory:currentWeapon", function(weapon)
     if currentRules["AllowedWeapons"] then
          local weaponAllowed = false

          if not weapon then return end

          for i, allowedWeapon in pairs(currentRules["AllowedWeapons"]) do
               if string.match(string.lower(weapon.name), string.lower(allowedWeapon)) then
                    weaponAllowed = true
                    break
               end
          end

          if weaponAllowed then
               DisableShooting(false)
          else
               DisableShooting(true)
          end
     end
end)


AddEventHandler("dmf->OnPlayerSpawn", (function(data)
     if currentRules["onSpawnGiveVehicle"] then
          SetEntityInvincible(cache.ped, true)
          Wait(500)

          if DoesEntityExist(lastVeh) then
               DeleteEntity(lastVeh)
          end

          local succes, data = lib.callback.await("dmf-core->CreateVehicle", false,
               tostring(currentRules["onSpawnGiveVehicle"]))

          if not succes then
               return mCore.Notify(lang.Title, "Something went wrong !", "error", 5000)
          end

          lastVeh = NetworkGetEntityFromNetworkId(data.netId)

          SetPedIntoVehicle(cache.ped, lastVeh, -1)
          Wait(800)
          SetEntityInvincible(cache.ped, false)
     end
end))

AddEventHandler("dmf->Died", (function(data)
     if currentRules["RespawnInArea"] then
          Wait(500)
          local pos = currentRules["RespawnInArea"].coords
          local radius = currentRules["RespawnInArea"].radius

          if not currentRules["RespawnInArea"].coords.xyz then
               mCore.error(("[RespawnInArea]: Failed to respawn no coords is givven [%s - %s]"):format(gm, mode))
               print(("[RespawnInArea]: Failed to respawn no coords is not givven [%s - %s]"):format(gm, mode))
               return
          end

          local function getRandomPosition()
               local angle = math.random() * 2 * math.pi
               print("Angle: ", angle)
               local distance = math.sqrt(math.random()) * radius
               print("Distance: ", distance)
               local oX = math.cos(angle) * distance
               local oY = math.sin(angle) * distance
               print("oX, oY", json.encode(oX), json.encode(oY))

               local newPos = vec3(pos.x + oX, pos.y + oY, GetEntityCoords(cache.ped).z)
               print("newPos: ", json.encode(newPos))
               local success, newZ = GetGroundZFor_3dCoord(newPos.x, newPos.y, newPos.z, false)
               print(("found gZ = %s GroundZ: %s"):format(success, json.encode(newZ)))

               local startTime = GetGameTimer()

               while not success and (GetGameTimer() - startTime < 3000) do
                    Wait(50)
                    success, newZ = GetGroundZFor_3dCoord(newPos.x, newPos.y, newPos.z, false)
               end

               if success then
                    newPos = vec3(newPos.x, newPos.y, newZ)
                    print("newGZ: ", json.encode(newPos))
               else
                    newPos = vec3(newPos.x, newPos.y, pos.z)
                    print("Using Normal gZ", json.encode(newPos))
               end

               return newPos
          end


          local function check()
               Citizen.CreateThread((function()
                    Wait(800)
                    local mypos = GetEntityCoords(cache.ped)
                    local dist = #(mypos.xyz - pos.xyz)
                    local modifiedRad = radius * 1.2

                    if dist >= modifiedRad then
                         exports["mate-spawnmanager"]:Revive(pos)
                         SetEntityCoords(pos)
                    end
               end))
          end

          function respawn()
               local newPos = getRandomPosition()
               exports["mate-spawnmanager"]:Revive(newPos)

               check()
          end

          respawn()
     end

     if currentRules["RespawnFromList"] then
          Wait(500)
          local newPos = currentRules["RespawnFromList"][math.random(1, #currentRules["RespawnFromList"])]
          exports["mate-spawnmanager"]:Revive(newPos)
     end

     if currentRules["DenyRespawn"] then
          exports["mate-spawnmanager"]:stop()
     end

     if currentRules["RemoveVehicleAfterDie"] then
          if IsPedInAnyVehicle(cache.ped, false) then
               DeleteEntity(GetVehiclePedIsIn(cache.ped, false))
          end
     end

     if currentRules["RemoveVehicleAfterDie2"] then
          if IsPedInAnyVehicle(cache.ped, false) then
               ExecuteCommand("dmf:removeVehicle")
          end
     end

     collectgarbage("collect")
end))


Citizen.CreateThread((function()
     TriggerServerEvent("mate-dimManager->RequestUpdate")
end))
RegisterCommand("rules:update", (function()
     TriggerServerEvent("mate-dimManager->RequestUpdate")
end))

function DisableShooting(state)
     if action == state then return end
     action = state

     -- ? --
     Citizen.CreateThread((function()
          while action do
               DisableControlAction(0, 69, state)
               DisableControlAction(0, 68, state)
               DisableControlAction(0, 24, state)
               Wait(1)
          end
     end))
end
