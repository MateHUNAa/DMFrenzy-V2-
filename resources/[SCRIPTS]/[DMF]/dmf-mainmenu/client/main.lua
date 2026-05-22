ESX     = exports['es_extended']:getSharedObject()
mCore   = exports["mCore"]:getSharedObj()

cam     = nil
visible = false

RegisterNUICallback("exit", function(body, cb)
     SetNuiFocus(false, false)
     visible = false
     stopCam(cam)
     cb("ok")
end)


RegisterNetEvent('mate-wagerv2->MatchFound', function()
     mCore.Notify("[DMF Wager]", "Match Found !", "info", 5000)
     stopCam(cam)
     SetNuiFocus(false, false)
     visible = false


     SendNUIMessage({
          action = "matchmakeSetVisibility",
          data   = false
     })

     SendNUIMessage({
          action = "setVisibility",
          data = false
     })
end)

RegisterNUICallback("toggleMatchmake", function(state, cb)
     cb('ok')

     SendNUIMessage({
          action = "matchmakeSetVisibility",
          data   = state
     })
     mCore.Notify("[DMF]", ("You %s the matchmake !"):format(state and "Enabled" or "Disabled"), "info", 5000)
     TriggerServerEvent("mate-wagerv2:ToggleMatchmake", state)
end)

OpenPanel = (function()
     if visible then return end
     local data = lib.callback.await("dmf-mainmenu->GetDat", false)

     local playerData = lib.callback.await("dmf->getPlayerData", false)

     TriggerServerEvent('dmf-core->SelfDim')

     TriggerEvent('dmf->HideHUD')
     DisplayRadar(false)

     local spawnPos = mCore.getSpawnCoords()
     TeleportPlayer(spawnPos.xyz)
     SetEntityHeading(cache.ped, spawnPos.w)
     Wait(200)
     initCam(cache.ped)

     local kdData = playerData.kd or {
          kills = 0,
          deaths = 0,
          headshot = 0,
     }

     SendNUIMessage({
          action = "loadPlayer",
          data   = {
               kill      = kdData.kills or 0,
               death     = kdData.deaths or 0,
               headshots = kdData.headshot or 0,
               playTime  = playerData.playedTime.ms or 0,
               name      = playerData.discord.name or "N/A",
               imageURL  = playerData.discord.img or false
          }
     })

     SendNUIMessage({
          action = "loadGamemodes",
          data = FormatData(data)
     })
     visible = true

     SendNUIMessage({
          action = "open",
          data = visible
     })
     SetNuiFocus(visible, visible)
end)
exports("Open", OpenPanel)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
     while not ESX.IsPlayerLoaded() do Wait(1000) end
     Wait(5000)


     ShutdownLoadingScreen()
     ShutdownLoadingScreenNui()
     Wait(50)
     OpenPanel()
end)


FormatData = (function(data)
     local cfg = {}
     for key, entry in pairs(data) do
          local currentPlayer = lib.callback.await("dmf-mainmenu->GetPlayerCount", false, entry.id, "DMF")
          local newEntry = {
               id             = entry.id,
               label          = entry.label,
               currentPlayers = currentPlayer,
               maxPlayers     = entry.maxPlayers,
               restrictLabels = entry.restrictLabel
          }
          table.insert(cfg, newEntry)
     end
     return cfg
end)


---@param gm string
---@param mode string
---@return boolean|vector4
GetOutPos = (function(gm, mode)
     for i, v in pairs(Config.Gamemodes) do
          if v.id == gm then
               -- for i, _mode in pairs(v.modes) do
               --      if _mode.id == mode then
               --           return _mode.outPos
               --      end
               -- end
               return v.outPos
          end
     end
     return false
end)

---@param pos vector3|vector4
---@param handleCam? boolean
TeleportPlayer = (function(pos, handleCam)
     local timeout <const> = 5000

     DoScreenFadeOut(800)
     while not IsScreenFadedOut() do
          Wait(99)
     end

     RequestCollisionAtCoord(pos.x, pos.y, pos.z)
     while not HasCollisionLoadedAroundEntity(cache.ped) and GetGameTimer() < timeout do
          Wait(100)
     end

     SetEntityCoordsNoOffset(cache.ped, pos.x, pos.y, pos.z + 1, false, false, false)
     if type(pos) == "vector4" then
          SetEntityHeading(cache.ped, pos.w)
     end
     FreezeEntityPosition(cache.ped, true)
     while not HasCollisionLoadedAroundEntity(cache.ped) and GetGameTimer() < timeout do
          Wait(100)
     end
     FreezeEntityPosition(cache.ped, false)

     if handleCam then
          stopCam()
     end

     DoScreenFadeIn(2000)
end)

-- Camera
function initCam(entity)
     FreezeEntityPosition(cache.ped, true)
     ClearFocus()
     local playerCoords = GetEntityCoords(cache.ped)
     local headCoords = GetPedBoneCoords(cache.ped, 0x796e, 0.0, 0.0, 0.0)

     Functions.lookEnt(Config.CameraPos.xyz + 0.5)
     local cam = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", Config.CameraPos.x, Config.CameraPos.y,
          Config.CameraPos.z + .5, 0, 0, 0, GetGameplayCamFov() - 2)
     SetCamActive(cam, true)
     RenderScriptCams(true, false, 0, false, false)

     PointCamAtCoord(cam, headCoords.x, headCoords.y, headCoords.z)

     return cam
end

function stopCam(cam)
     ClearFocus()
     RenderScriptCams(false, false, 0, false, false)
     DestroyCam(cam, false)
     FreezeEntityPosition(cache.ped, false)
end

Citizen.CreateThread((function()
     while not ESX.IsPlayerLoaded() do Wait(1000) end
     Wait(1000)

     ShutdownLoadingScreen()
     ShutdownLoadingScreenNui()
     Wait(50)
     OpenPanel()
end))
