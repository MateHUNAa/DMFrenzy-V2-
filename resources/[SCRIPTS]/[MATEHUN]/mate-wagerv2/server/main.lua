ESX           = exports['es_extended']:getSharedObject()
mCore         = exports["mCore"]:getSharedObj()

Requests      = {}
Matches       = {}
Matchmake     = {}
PlayersInGame = {}
Scores        = {}



RegisterNetEvent('mate-kd:onKill', function(killer, victim, headshot)
     local killerMatchId = PlayersInGame[tostring(killer.sourceId)]
     local victimMatchId = PlayersInGame[tostring(victim.sourceId)]

     if source == victim.sourceId then
          return
     end

     if not killerMatchId then return end
     if not victimMatchId then return end
     if killerMatchId ~= victimMatchId then return end

     local matchId = killerMatchId

     if not Scores[matchId] then
          Scores[matchId] = {}
          Scores[matchId][tostring(killer.sourceId)] = { score = 0 }
          Scores[matchId][tostring(victim.sourceId)] = { score = 0 }
     end

     local Match = Matches[matchId]

     Scores[matchId][tostring(killer.sourceId)].score = Scores[matchId][tostring(killer.sourceId)].score + 1

     TriggerClientEvent("mate-wagerv2->WagerScoreUpdate", killer.sourceId, Scores[matchId], Match)
     TriggerClientEvent("mate-wagerv2->WagerScoreUpdate", victim.sourceId, Scores[matchId], Match)

     Wait(155)

     local function Teleport(pid, i)
          Wait(450)
          local ped = GetPlayerPed(pid)
          SetEntityCoords(ped, Config.Spawns[i].x, Config.Spawns[i].y, Config.Spawns[i].z, true,
               false, false, false)
          FreezeEntityPosition(ped, true)
          TriggerClientEvent("dmf-spawnmanager->Revive", pid,
               vec3(Config.Spawns[i].x, Config.Spawns[i].y, Config.Spawns[i].z))

          TriggerClientEvent("mate-wagerv2:Countdown", pid)
     end

     if Scores[matchId][tostring(killer.sourceId)].score >= Match.matchData.rounds then
          Wait(450)
          TriggerClientEvent("dmf-spawnmanager->Revive", killer.sourceId)
          TriggerClientEvent("dmf-spawnmanager->Revive", victim.sourceId)
          Wait(300)
          lib.callback.await("mate-wagerv2:RequestAnimationLibary", killer.sourceId)
          lib.callback.await("mate-wagerv2:RequestAnimationLibary", victim.sourceId)
          Wait(1000)
          RemovePlayerFromWager(killer.sourceId, matchId)
          Wait(500)
          RemovePlayerFromWager(victim.sourceId, matchId)

          print(json.encode(Scores[matchId]))
          Scores[matchId] = nil

          if Match.matchData.bet > 0 then
               local s, r = exports.ox_inventory:AddItem(killer.sourceId, "money", Match.matchData.bet * 2)
               mCore.sendMessage(("[AddItem]: wager bet:`%s` to %s(%s) Success: %s matchData: ```lua\n%s\n```"):format(
                    Match.matchData.bet,
                    GetPlayerName(killer.sourceId), tostring(killer.sourceId),
                    s and "✅" or "❌",
                    json.encode(Match)
               ), mCore.RequestWebhook("money"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))

               -- TODO: Destory wager dimension
          end

          if not s then
               print("Failed to give the wager bet to the winner:", r, "\n## MatchData:",
                    json.encode(Match, { indent = true }))
          end
          return
     end

     Teleport(Match.fromId, 1)
     Teleport(Match.sourceId, 2)
end)
