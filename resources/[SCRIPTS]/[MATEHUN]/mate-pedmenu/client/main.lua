ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


local lang                   = Loc[Config.lan]
Cam                          = nil
Visible                      = false

local peds                   = {}
local maxPed                 = 0
local currentPed, currentIdx = peds[1] or nil, 0
local openPos                = vec3(0, 0, 0)
local render                 = false
RegisterCommand("pedmenu", (function()
     if Visible then
          StopCam()
          Visible = false
          FreezeEntityPosition(cache.ped, false)
          NetworkSetEntityInvisibleToNetwork(cache.ped, false)
          LocalPlayer.state.canUseWeapons = true
          DisableControls(Visible)

          return
     else
          Visible = true
          FreezeEntityPosition(cache.ped, true)
          NetworkSetEntityInvisibleToNetwork(cache.ped, true)
          LocalPlayer.state.canUseWeapons = false
          DisableControls(Visible)
     end

     peds = lib.callback.await("mate-pedmenu->RequestPeds", false)

     if not peds or next(peds) == nil then
          StopCam()
          Visible = false

          Info(lang.info["noPeds"])
          return
     end

     for i, v in pairs(peds) do maxPed = i end

     SetEntityAlpha(cache.ped, 0, false)


     RenderPed(peds[1])
     currentIdx = 1
end), false)

--
-- Commands
--

RegisterCommand("pedmenu->doRight", function(source, args, raw)
     if not Visible then return end
     if currentIdx >= maxPed then
          currentIdx = 1
     else
          currentIdx += 1
     end

     RenderPed(peds[currentIdx])
end, false)

RegisterCommand("pedmenu->doLeft", function(source, args, raw)
     if not Visible then return end
     if currentIdx <= 1 then
          currentIdx = maxPed
     else
          currentIdx -= 1
     end

     RenderPed(peds[currentIdx])
end, false)

RegisterCommand("pedmenu->doExit", function(source, args, raw)
     if not Visible then return end

     LocalPlayer.state.canUseWeapons = true
     StopCam()
     Visible = false

     if DoesEntityExist(currentPed) then
          DeleteEntity(currentPed)
     end
end, false)

RegisterCommand("pedmenu->doAccept", function(source, args, raw)
     if not Visible then return end
     lib.requestModel(peds[currentIdx])

     if not HasModelLoaded(peds[currentIdx]) then
          return mCore.Notify("[DMF Pedmenu]", "Failed to load your ped !", "error", 5000)
     end

     if DoesEntityExist(currentPed) then
          DeleteEntity(currentPed)
          currentPed = nil
     end
     StopCam()

     SetPlayerModel(PlayerId(), peds[currentIdx])
     SetModelAsNoLongerNeeded(peds[currentIdx])

     local defaultPed = false
     for i, v in pairs(Config.DefaultPeds) do
          if v == peds[currentIdx] then
               defaultPed = true
               break
          end
     end

     if not defaultPed then return end
     ApplyDefaultSkin()
end, false)

RegisterKeyMapping("pedmenu->doRight", "Pedmenu change ped Right", "keyboard", "RIGHT")
RegisterKeyMapping("pedmenu->doLeft", "Pedmenu change ped Left", "keyboard", "LEFT")
RegisterKeyMapping("pedmenu->doExit", "Pedmenu->Exit menu", "keyboard", "BACK")
RegisterKeyMapping("pedmenu->doAccept", "Pedmenu->Accept ped", "keyboard", "ENTER")

--
-- Functions
--
StopCam = (function()
     Visible = false
     render = false
     FreezeEntityPosition(cache.ped, false)
     SetEntityAlpha(cache.ped, 255, false)
end)


local loading    = false
local thread     = false
RenderPed        = (function(model)
     if not loading then loading = true else return end
     render = false
     Wait(100)

     if not IsModelInCdimage(model) then
          StopCam()
          Visible = false
          loading = false
          StopCam()
          if DoesEntityExist(currentPed) then
               DeleteEntity(currentPed)
               currentPed = nil
          end
          return print(("[RenderPed]: model is not in cd image: %s"):format(model))
     end

     if DoesEntityExist(currentPed) then
          DeleteEntity(currentPed)
          currentPed = nil
     end

     lib.requestModel(model)

     local timeout = GetGameTimer() + 5000
     while not HasModelLoaded(model) do
          Wait(200)
          if GetGameTimer() > timeout then
               print("[RenderPed]: Failed to load ped model !")
               loading = false
               return false
          end
     end

     currentPed = CreatePed(0, model, 0, 0, 0, 0, false, true)
     SetModelAsNoLongerNeeded(model)
     NetworkSetEntityInvisibleToNetwork(currentPed, true)

     local positionBuffer = {}
     local bufferSize = 5

     render = true

     if not thread then
          Citizen.CreateThread((function()
               thread = true
               while render do
                    if not render then break end
                    local screencoordsX = 0.46
                    local screencoordsY = 0.7

                    local world, normal = GetWorldCoordFromScreenCoord(screencoordsX, screencoordsY)
                    local depth         = 6.0
                    local target        = world + normal * depth
                    local camRot        = GetGameplayCamRot(2)

                    table.insert(positionBuffer, target)
                    if #positionBuffer > 5 then
                         table.remove(positionBuffer, 1)
                    end

                    local averagedTarget = vector3(0, 0, 0)
                    for _, position in ipairs(positionBuffer) do
                         averagedTarget = averagedTarget + position
                    end
                    averagedTarget = averagedTarget / #positionBuffer


                    SetEntityCoords(currentPed, averagedTarget.x, averagedTarget.y, averagedTarget.z, false, false, false,
                         true)
                    local heading_offset = 190.0
                    SetEntityHeading(currentPed, camRot.z + heading_offset)
                    SetEntityRotation(currentPed, camRot.x * (-1), 0.0, camRot.z + 170.0, 2, false)

                    Wait(4)
               end
               thread = false
          end))
     end

     loading = false
     return true
end)

ApplyDefaultSkin = (function()
     local skin = lib.callback.await("mate-pedmenu->RequestSkin", false)

     if not skin then return print("FATAL ERR: No skin") end

     if skin.sex == 0 then
          model = GetHashKey("mp_m_freemode_01")
     else
          model = GetHashKey("mp_f_freemode_01")
     end

     TriggerEvent('skinchanger:loadSkin', skin)
     SetEntityHealth(cache.ped, GetEntityMaxHealth(cache.ped))
end)


local action = false
function DisableControls(state)
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

--
-- Events
--
AddEventHandler("onResourceStop", (function(res)
     if GetCurrentResourceName() ~= res then return end

     if Visible then
          StopCam()
     end

     if DoesEntityExist(currentPed) then
          DeleteEntity(currentPed)
     end
end))


lib.callback.register("mate-pedmenu->IsModelExist", (function(model)
     return IsModelInCdimage(model)
end))


RegisterNetEvent('mate-pedmenu->PedRemoved', function(removedPed)
     local currentPedModel = GetEntityModel(cache.ped)
     local removedPedModel = GetHashKey(removedPed)

     if currentPedModel == removedPedModel then
          ApplyDefaultSkin()
     end
end)


RegisterNetEvent('mate-vipsystem->VipExpired', function()
     local currentPedModel = GetEntityModel(cache.ped)

     for i, v in pairs(Config.VIPPeds) do
          if GetHashKey(v.ped) == currentPedModel then
               ApplyDefaultSkin()
          end
     end
end)
