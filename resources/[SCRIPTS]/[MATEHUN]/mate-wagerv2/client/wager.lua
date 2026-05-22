local isRequstsHudVisible = false
local isScoreHudVisible = false

RegisterCommand("wager", (function(src, args, raw)
     local target = tonumber(args[1])
     local rounds = tonumber(args[2])
     local bet    = tonumber(args[3])


     if #args < 3 then
          return Error(lang.error["args_mismatch"])
     end

     if tonumber(rounds) > 15 then
          return Error(lang.error["max_rounds"])
     end

     if tonumber(rounds) <= 0 then
          return Error(lang.error["min_rounds"])
     end

     TriggerServerEvent('mate-wagerv2:InitiateMatch', {
          targetId = target,
          rounds   = tonumber(rounds),
          bet      = tonumber(bet)
     })
end))



function OpenRequests(state)
     isRequstsHudVisible = state or not isRequstsHudVisible

     SendNUIMessage({
          action = "reqToggleHud",
          data = isRequstsHudVisible
     })
     SetNuiFocus(isRequstsHudVisible, isRequstsHudVisible)
end

RegisterNUICallback("exit", function(body, cb)
     cb("ok")
     SetNuiFocus(false, false)
end)

RegisterCommand("requests", (function(src, args, raw)
     OpenRequests()
end))

---@param data { matchId: string, fromId: number, targetId: number }
RegisterNetEvent('mate-wagerv2:SendRequest', function(data)
     if not data or next(data) == nil then return end

     Info(lang.info["request_added"])
     SendNUIMessage({
          action = "insertRequest",
          data   = data
     })
end)


RegisterNUICallback("accept-request", function(data, cb)
     cb("ok")
     OpenRequests(false)
     TriggerServerEvent("mate-wagerv2:RequestAccepted", data)
end)
RegisterNUICallback("decline-request", function(data, cb)
     cb("ok")
     OpenRequests(false)
     TriggerServerEvent("mate-wagerv2:RequestDeclined", data)
end)

RegisterNetEvent('mate-wagerv2:ShowWagerHUD', function(request)
     TriggerEvent("dmf->HideHUD")
     isScoreHudVisible = true

     SendNUIMessage({
          action = "scoreToggleHud",
          data   = isScoreHudVisible
     })

     Wait(200)

     SendNUIMessage({
          action = "scoreUpdate",
          data = {
               fromPlayer   = {
                    playerName = request.fromData.discordName,
                    imageURL   = request.fromData.imageURL,
                    score      = 0
               },
               sourcePlayer = {
                    playerName = request.sourceData.discordName,
                    imageURL   = request.sourceData.imageURL,
                    score      = 0
               },
          }
     })
end)

RegisterNetEvent('mate-wagerv2->WagerScoreUpdate', function(Scores, Match)
     local data = {
          fromPlayer   = {
               playerName = Match.fromData.discordName,
               imageURL   = Match.fromData.imageURL,
               score      = Scores[tostring(Match.fromId)].score
          },
          sourcePlayer = {
               playerName = Match.sourceData.discordName,
               imageURL   = Match.sourceData.imageURL,
               score      = Scores[tostring(Match.sourceId)].score
          },
     }

     print("[WagerScoreUpdate]", json.encode(data, {
          indent = true
     }))

     SendNUIMessage({
          action = "scoreUpdate",
          data = data
     })
end)

RegisterNetEvent('mate-wagerv2:Countdown', function()
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
          FreezeEntityPosition(cache.ped, false)
     end))
     Wait(5000)
     asd = false
end)

RegisterNetEvent('mate-wagerv2:WagerEnd', function()
     print("[WagerEnd]")
     isScoreHudVisible = false
     SendNUIMessage({
          action = "scoreToggleHud",
          data   = isScoreHudVisible
     })

     Wait(2000)
     -- exports["dmf-mainmenu"]:Open()
     Wait(500)
     SetEntityInvincible(cache.ped, false)
end)

function Draw2DText(text)
     SetTextFont(font)
     SetTextScale(0.88, 0.88)
     SetTextColour(255, 165, 0, 150)
     SetTextOutline()
     SetTextCentre(true)

     BeginTextCommandDisplayText("STRING")
     AddTextComponentSubstringPlayerName(text)
     EndTextCommandDisplayText(.5, .5)
end

lib.callback.register("mate-wagerv2:RequestAnimationLibary", (function(state)
     SetEntityInvincible(cache.ped, state)
end))
