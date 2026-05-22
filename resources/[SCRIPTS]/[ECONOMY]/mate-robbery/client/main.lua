ESX                = exports['es_extended']:getSharedObject()
mCore              = exports["mCore"]:getSharedObj()
local lang         = Loc[Config.lan]

local currentRules = {}
RegisterNetEvent("mate-dimManager->Update", (function(data)
     currentRules = data.rules
end))

local robbing      = false
local font         = mCore.getFont("BebasNeueOtf")
local debug        = false
local currentStore = nil

Blips              = {}
ActiveBlips        = {}

RegisterCommand("mhrob:debug", (function()
     debug = not debug
end), false)

Citizen.CreateThread((function()
     for k, v in pairs(Config.Shops) do
          for i, pos in pairs(Config.Shops[k].coords) do
               local shopId      = "robbery" .. "_" .. k .. "_" .. i
               local marker      = Config.MarkerTemplates[k]
               marker.pos        = pos.xyz
               marker.id         = shopId
               marker.onInteract = (function()
                    local bucket, dim = lib.callback.await('mate-dimManager->GetCurrentDim')
                    if not dim.rules["RobberyAllowed"] then
                         return mCore.Notify("[DMF Rules]", "You cannot start a robbery in this dimension !", "error",
                              5000)
                    end
                    local canRob, passedTime, errNum = lib.callback.await("shoprob->OnCooldown", false, shopId, k)
                    if not canRob then
                         if errNum == 1 then
                              Error((lang.error["limit_reach"]))
                              return
                         end

                         Error(string.format(lang.error["onCooldown"],
                              type(passedTime) == "number" and
                              Functions.ParseGameTimeToHumaneTime(passedTime or 1000)) or "")
                         return
                    end

                    TriggerEvent("shoprob->Start", shopId, k, --[[ Type ]] i --[[ Index ]])
               end)


               Blips["Blip" .. k .. i] = Functions.makeBlip({
                    name     = ("%s"):format(k),
                    coords   = pos.xyz,
                    sprite   = Config.Shops[k].Sprite,
                    col      = Config.Shops[k].Col,
                    scale    = v.size,
                    category = v.category
               })
               exports["mate-markers"]:AddMarker(marker)
          end
     end
     --
end))


--
-- Events
--

RegisterNetEvent('mate-kd:onkill', function()
     if not robbing then return end


     TriggerServerEvent("shoprob->Failed", currentStore)
end)

RegisterNetEvent('shoprob->Start', function(storeId, type, i)
     if not robbing then robbing = true else return end

     currentStore = storeId

     local lastUpdate = GetGameTimer()
     local startTime = GetGameTimer()
     local cooldown = Config.Shops[type].Cooldown

     local text = lang.info["TimeToRob"]

     local shop = Config.Shops[type].coords[i]
     local distance = Config.Shops[type].Distance

     TriggerServerEvent('shoprob->DisplayBlip', storeId, shop.xyz)
     Success(lang.success["start"])
     while robbing do
          local dist = #(GetEntityCoords(cache.ped).xy - shop.xy)

          if debug then
               DrawMarker(
                    1,
                    shop.x, shop.y, shop.z + 1,
                    0.0, 0.0, 0.0,
                    0.0, 0.0, 0.0,
                    distance, distance, 2.0,
                    0, 255, 0, 100,
                    false, false, 2, false, nil, nil, false
               )
          end


          if dist >= Config.Shops[type].Distance then
               robbing = false
               TriggerServerEvent("shoprob->Failed", storeId)

               currentStore = nil
               if debug then
                    print("You failed the robbery zone left")
               end

               break
          end

          local elapsedTime = GetGameTimer() - startTime
          local remainingTime = math.max(0, cooldown - elapsedTime)

          if (remainingTime <= 0) then
               robbing = false
               TriggerServerEvent('shoprob->Complete', type, storeId)
               currentStore = nil

               if Blips[storeId] then
                    if DoesBlipExist(Blips[storeId]) then
                         RemoveBlip(Blips[storeId])
                    end
               end
               break
          end

          if (GetGameTimer() - lastUpdate) >= 1000 then
               text = lang.info["TimeToRob"] .. Functions.ParseGameTimeToHumaneTime(remainingTime)
               lastUpdate = GetGameTimer()
          end

          Draw2DText(text)
          Wait(1)
     end
end)

RegisterNetEvent("shoprob->RemoveBlips", (function(storeId)
     if DoesBlipExist(ActiveBlips[storeId]) then
          RemoveBlip(ActiveBlips[storeId])
     else
          print(("%s store is not blip not exist"):format(storeId))
     end
end))

RegisterNetEvent('shoprob->CreateActiveBlip', function(coords, shopId)
     Info(lang.info["ChipyVagyokBuzi"])
     if ActiveBlips[shopId] then
          if DoesBlipExist(ActiveBlips[shopId]) then
               RemoveBlip(ActiveBlips[shopId])
          end
     end

     ActiveBlips[shopId] = Functions.makeBlip({
          coords = coords.xyz,
          name   = lang.info["active_rob"],
          sprite = 161,
          scale  = .75,
          col    = 1
     })
end)


AddEventHandler("onResourceStop", (function(res)
     if GetCurrentResourceName() ~= res then return end

     for i = 1, #Blips do
          local b = Blips[i]

          if DoesBlipExist(b) then
               RemoveBlip(b)
          end
     end

     for i = 1, #ActiveBlips do
          local b = ActiveBlips[i]
          if DoesBlipExist(b) then
               RemoveBlip(b)
          end
     end
end))



--
-- Functions
--

function Draw2DText(text)
     SetTextFont(font)
     SetTextScale(0.5, 0.5)
     SetTextColour(255, 165, 0, 150)
     SetTextOutline()
     SetTextCentre(true)

     BeginTextCommandDisplayText("STRING")
     AddTextComponentSubstringPlayerName(text)
     EndTextCommandDisplayText(.5, .02)
end

--
-- Debug Commands
--

RegisterCommand("robbery:wipeBlips", (function(src, args, raw)
     for i = 1, #ActiveBlips do
          local b = ActiveBlips[i]
          if DoesBlipExist(b) then
               RemoveBlip(b)
          end
     end
end))
