ESX = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


local rimeRanks = {}

Citizen.CreateThread(function()
     MySQL.query("SELECT * FROM `rime_rang`", {}, function(res)
          if res then
               local loaded = 0


               table.sort(res, function(a, b)
                    return a["required_kills"] > b["required_kills"]
               end)

               for i, row in ipairs(res) do
                    rimeRanks[row["name"]] = {
                         data = row
                    }
                    loaded += 1
               end

               mCore.log(("Loaded ^3%s^0 Ranks !"):format(loaded))
          else
               mCore.error("[rankSystem]: Error while getting ranks !", false)
          end
     end)
end)

RegisterNetEvent("mate-kd:onKill", function(killer)
     if not killer then return end
     if not killer.type == "player" then return end

     local xPlayer     = mCore.getXPlayer(killer.sourceId)
     local identifer   = xPlayer.getIdentifier()
     local kills       = nil
     local currentRank = nil

     MySQL.query("SELECT kills,rang FROM `mate_kd` WHERE identifier = ?", {
          identifer
     }, function(response)
          if response then
               kills = response[1]["kills"] + 1 or 1
               currentRank = response[1]["rang"]

               local function compareRanks(a, b)
                    return a.data.required_kills > b.data.required_kills
               end

               local sortedRanks = {}
               for _, rank in pairs(rimeRanks) do
                    table.insert(sortedRanks, rank)
               end
               table.sort(sortedRanks, compareRanks)

               for _, rank in ipairs(sortedRanks) do
                    if kills >= rank.data.required_kills then
                         if currentRank == rank.data.name then return end
                         updatePlayerRank(xPlayer, rank.data.name)
                         break
                    end
               end
          else
               mCore.error("[rankSystem]: Error while getting player kills ! ", false)
          end
     end)
end)


function updatePlayerRank(xPlayer, rank)
     local identifier = xPlayer.getIdentifier()

     MySQL.Async.execute("UPDATE `mate_kd` SET rang = ? WHERE identifier = ?", {
          rank,
          identifier
     }, function(rowsChanged)
          if rowsChanged > 0 then
               mCore.debug.log(("Player rank was changed to (%s)"):format(rank))
               TriggerEvent("mate-kd:newRank", xPlayer, rank, GetCurrentResourceName())
          else
               mCore.error(
                    ("Error while updating user rank! %s(%s) | newRank: %s"):format(GetPlayerName(xPlayer.source),
                         xPlayer.source, rank), isLocal)
               mCore.sendMessage(
                    ("Error while updating user rank! %s(%s) | newRank: %s"):format(GetPlayerName(xPlayer.source),
                         xPlayer.source, rank), mCore.getHook(), "Rank System")
          end
     end)
end
