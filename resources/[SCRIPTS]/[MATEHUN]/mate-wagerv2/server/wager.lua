local lang = Loc[Config.lan]

---@param data { targetId: number, rounds: number, bet: number }
RegisterNetEvent('mate-wagerv2:InitiateMatch', function(data)
     local source = source
     if not data or next(data) == nil then return end

     local xPlayer = mCore.getXPlayer(source)
     local xTarget = mCore.getXPlayer(data.targetId)


     if PlayersInGame[tostring(xTarget.source)] or PlayersInGame[tostring(xPlayer.source)] then
          return
     end


     local c1 = exports.ox_inventory:Search(data.targetId, "count", "money")
     local c2 = exports.ox_inventory:Search(source, "count", "money")

     if c1 <= data.bet then
          return mCore.Notify(source, lang.Title, lang.error["target_no_money"], "error", 5000)
     end
     if c2 <= data.bet then
          return mCore.Notify(source, lang.Title, lang.error["you_no_money"], "error", 5000)
     end

     exports.ox_inventory:RemoveItem(data.targetId, "money", data.bet)
     exports.ox_inventory:RemoveItem(xPlayer.source, "money", data.bet)

     if not xPlayer or not xTarget then
          return print("FATAL-> xPlayer or xTarget is nill")
     end

     local matchId = Shared.RandomID(12)


     local playerData = exports["dmf-core"]:GetPlayerData(xPlayer.source)
     local fromDiscord = playerData.discord
     if not fromDiscord or next(fromDiscord) == nil then
          print(("Failed to get %s fromDiscord"):format(xPlayer.source))
          fromDiscord = {
               name = GetPlayerName(xPlayer.source) or "N/A",
               id   = "N/A",
               img  = false
          }
     end

     local sourceData = exports["dmf-core"]:GetPlayerData(xTarget.source)
     local sourceDiscord = sourceData.discord
     if not sourceDiscord or next(sourceDiscord) == nil then
          print(("Failed to get %s sourceDiscord"):format(xTarget.source))
          sourceDiscord = {
               name = GetPlayerName(xTarget.source) or "N/A",
               id   = "N/A",
               img  = false
          }
     end



     Requests[matchId] = {
          matchId    = matchId,
          fromId     = source,
          sourceId   = xTarget.source,

          matchData  = {
               bet    = data.bet,
               rounds = data.rounds,
               weapon = "WEAPON_APPISTOL"
          },

          fromData   = {
               discordName = fromDiscord.name,
               discordId   = fromDiscord.id,
               imageURL    = fromDiscord.img
          },
          sourceData = {
               discordName = sourceDiscord.name,
               discordId   = sourceDiscord.id,
               imageURL    = sourceDiscord.img
          },
          createdAt  = GetGameTimer()
     }

     TriggerClientEvent("mate-wagerv2:SendRequest", xTarget.source, Requests[matchId])
     mCore.Notify(xPlayer.source, lang.Title,
          string.format(lang.info["request_sent"], GetPlayerName(xTarget.source), tostring(xTarget.source)), "info",
          5000)
end)


RegisterNetEvent('mate-wagerv2:RequestDeclined', function(matchId)
     mCore.Notify(Requests[matchId].fromId, lang.Title, lang.info["req_declined"], "info", 5000)
     Requests[matchId] = nil
end)


RegisterNetEvent('mate-wagerv2:RequestAccepted', function(matchId, isMatchmake)
     local request = Requests[matchId]
     if not isMatchmake then
          mCore.Notify(request.fromId, lang.Title, lang.info["req_accepted"], "info", 5000)
     end

     local found, _, _, keys = exports["mate-dimManager"]:GetPlayer(request.fromId)
     if found then
          exports["mate-dimManager"]:RemovePlayer(request.fromId, keys.gamemode, keys.mode)
     end

     local found, _, _, keys = exports["mate-dimManager"]:GetPlayer(request.sourceId)
     if found then
          exports["mate-dimManager"]:RemovePlayer(request.sourceId, keys.gamemode, keys.mode)
     end

     request.bucketId = exports["mate-dimManager"]:Create("wager", request.matchId, {
          ["DenyRespawn"]  = true,
          ["DenyVehicles"] = true,
     })

     Wait(500)

     StartGame(request.fromId, 1, request)
     StartGame(request.sourceId, 2, request)

     Matches[request.matchId] = request
     Requests[matchId]        = nil

     collectgarbage("collect")
end)


function StartGame(pid, i, request)
     local ped                    = GetPlayerPed(pid)
     PlayersInGame[tostring(pid)] = request.matchId

     exports["mate-dimManager"]:AddPlayer(pid, "wager", request.matchId)

     SetEntityCoords(ped, Config.Spawns[i].x, Config.Spawns[i].y, Config.Spawns[i].z, true,
          false, false, false)


     FreezeEntityPosition(ped, true)

     TriggerClientEvent('mate-wagerv2:ShowWagerHUD', pid, request)
     TriggerClientEvent('mate-wagerv2:Countdown', pid)
end

function RemovePlayerFromWager(pid, matchId)
     TriggerClientEvent("dmf-spawnmanager->Revive", pid,
          vec3(Config.Spawns[1].x, Config.Spawns[1].y, Config.Spawns[1].z))
     Wait(500)
     exports["mate-dimManager"]:RemovePlayer(pid, "wager", matchId)
     PlayersInGame[tostring(pid)] = nil
     TriggerClientEvent("mate-wagerv2:WagerEnd", pid)
     SetPlayerRoutingBucket(pid, 0)
end
