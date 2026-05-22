ESX              = exports['es_extended']:getSharedObject()
lang             = Loc[Config.lan]

local Camera     = require 'client.camera'
local Timer      = require 'client.deathTimer'

local firstSpawn = true
isDead, isBusy   = false, false

RegisterNetEvent("esx:playerLoaded", (function()
     ESX.PlayerLoaded = true
     Wait(500)
     local p = GetEntityCoords(cache.ped)
     RespawnPed(cache.ped, vec4(p.x, p.y, p.z, GetEntityHeading(cache.ped)))
end))

-- Fixed: If resource restart's when the player died !
Citizen.CreateThread((function()
     if GetEntityHealth(cache.ped) == 0 then
          OnPlayerDeath()
     end
end))

RegisterNetEvent("esx:onPlayerSpawn", (function()
     isDead = false

     ClearTimecycleModifier()
     ClearExtraTimecycleModifier()
     SetPedMotionBlur(cache.ped, false)

     Camera.Destroy()

     if firstSpawn then
          firstSpawn = false

          if Config.SaveDeathStatus then
               while not ESX.PlayerLoaded do
                    Wait(1000)
               end

               local shouldDie = lib.callback.await("dmf-spawnmanager->getDeathStatus", false)

               if shouldDie then
                    Wait(1000)
                    SetEntityHealth(cache.ped, 0)
               end
          end
     end
end))

RegisterNetEvent("esx:onPlayerDeath", (function(data)
     OnPlayerDeath(data)
end))

--
-- Events
--

local isReviveing = false
RegisterNetEvent('dmf-spawnmanager->Revive', function(coords)
     if not isReviveing then isReviveing = true else return end

     local mypos = coords or GetEntityCoords(cache.ped)
     local myhead = GetEntityHeading(cache.ped)

     LocalPlayer.state:set("dead", false, true)
     -- TriggerServerEvent("dmf-spawnmanager->setDeathStatus", false)

     DoScreenFadeOut(500)

     while not IsScreenFadedOut() do
          Wait(100)
     end

     RespawnPed(cache.ped, vec4(mypos.x, mypos.y, mypos.z, myhead))

     DoScreenFadeIn(500)

     Wait(500)
     isReviveing = false
end)

exports("Revive", function(pos)
     TriggerEvent("dmf-spawnmanager->Revive", pos)
end)

RegisterNetEvent('dmf-spawnmanager->StartReviveAnim', function(target)
     if isBusy then return else isBusy = true end
     if not target then return end
     --

     local dict, anim = 'mini@cpr@char_a@cpr_str', 'cpr_pumpchest'
     lib.requestAnimDict(dict, 5000)

     if not HasAnimDictLoaded(dict) then return end

     for i = 1, 15 do
          Wait(900)

          TaskPlayAnim(cache.ped, dict, anim, 8.0, -8.0, -1, 0, 0.0, false, false, false)
     end

     RemoveAnimDict(dict)

     TriggerServerEvent('dmf-spawnmanager->revive', target)
     --
end)

--
-- Callbacks
--

---@param data table
---@return boolean,boolean
---        Accepted,Error
lib.callback.register("dmf-spawnmanager->askForRevive", (function(data)
     if not isDead then return false, false end

     if not data then
          if debug then
               data.sourceJob = "TestJob"
               data.sourceName = "TestName"
          else
               return false, true
          end
     end

     Timer.Pause()

     local alert = lib.alertDialog({
          header   = "Respawn Request",
          content  = ("Revive request from : [%s] %s "):format(data.sourceJob, data.sourceName),
          centered = true,
          cancel   = true
     })

     if alert == "cancel" then
          Timer.Resume()
          return false, false
     end

     if alert == "confirm" then
          return true, false
     end

     return false, true
end))


--
-- Functions
--

function OnPlayerDeath(data)
     isDead = true
     LocalPlayer.state:set("dead", true, true)

     -- [[ Hide all Menu options ]] --
     pcall(function(...)
          ESX.CloseContext()
          lib.hideContext(false)
          lib.hideTextUI()
          if lib.skillCheckActive() then lib.cancelSkillCheck() end
          lib.hideRadial()
          lib.progressActive()
          lib.hideMenu(true)
          lib.closeAlertDialog()
     end)

     TriggerEvent("dmf->Died", data)
     TriggerServerEvent("dmf->Died", data)

     TriggerEvent('dmf->HideHUD')

     if Config.UseTimeCycleOnDeath then
          ClearTimecycleModifier()
          ClearExtraTimecycleModifier()
          SetExtraTimecycleModifier("spectator1")
          SetExtraTimecycleModifierStrength(1.0)
          SetPedMotionBlur(cache.ped, true)
     end

     TriggerServerEvent('dmf-spawnmanager->setDeathStatus', true)

     if data then
          if data.killedByPlayer then
               TriggerServerEvent('dmf-spawnmanager->KilledByPlayer', data)
               TriggerEvent("dmf-spawnmanager->KilledByPlayer", data)
          end
     else
          print("[OnPlayerDeath]: Something went wrong no death data")
     end

     -- Camera.StartDeathCam()
     Timer.StartTimer()

     --
end

---@param ped any
---@param coords vector4
function RespawnPed(ped, coords)
     RequestCollisionAtCoord(coords.x, coords.y, coords.z)

     while not HasCollisionLoadedAroundEntity(cache.ped) do
          Wait(250)
     end

     SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z, false, false, false)
     NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w, Config.SpawnProtection, false)
     SetPlayerInvincible(cache.ped, false)
     ClearPedBloodDamage(cache.ped)

     TriggerServerEvent("esx:onPlayerSpawn")
     TriggerEvent("esx:onPlayerSpawn")

     TriggerEvent("dmf->OnPlayerSpawn")
     TriggerServerEvent("dmf->OnPlayerSpawn")

     exports['dmf-hud']:toggle(true)
end

function RemoveItems()
     if not Config.RemoveItemsOnDead then return end

     local keep = {}

     for i, item in pairs(exports["ox_inventory"]:GetPlayerItems()) do
          if item.metadata and next(item.metadata) then
               if item.metadata.mhNoRemove then
                    table.insert(keep, item.name)
               end
          end
     end

     TriggerServerEvent("dmf-spawnmanager->RemoveItems", keep)
end

function GetClosestSpawn(mypos)
     local closest, coord = math.huge, nil

     for i, nextPos in pairs(Config.SpawnPoints) do
          local dist = #(mypos.xy - nextPos.xy)
          if dist < closest then
               closest, coord = dist, nextPos
          end
     end
     return coord
end
