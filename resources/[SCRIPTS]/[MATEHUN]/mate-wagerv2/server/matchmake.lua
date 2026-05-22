Citizen.CreateThread((function()
     Wait(2000)

     while true do
          local selected = {}
          local count = 0

          for playerId in pairs(Matchmake) do
               table.insert(selected, playerId)
               count += 1

               if count >= 2 then
                    break
               end
          end

          -- print(json.encode(Matchmake, { indent = true }), json.encode(selected))
          if count >= 2 and selected and (GetPlayerPing(selected[1]) ~= 0 and GetPlayerPing(selected[2]) ~= 0) then
               if PlayersInGame[tostring(selected[1])] then
                    Matchmake[selected[1]] = nil
               end

               if PlayersInGame[tostring(selected[2])] then
                    Matchmake[selected[2]] = nil
               end

               for _, id in ipairs(selected) do
                    print(("[Matchmake]: Removeing %s[%s] from the matchmake! ( MATCH FOUND )"):format(GetPlayerName(id),
                         id))

                    Matchmake[id] = nil
               end

               local matchId = "matchmake_" .. Shared.RandomID(12)
               local player1Data = exports["dmf-core"]:GetPlayerData(selected[1])
               local fromDiscord = player1Data.discord
               if not fromDiscord or next(fromDiscord) == nil then
                    print(("Failed to get %s fromDiscord"):format(selected[1]))
                    fromDiscord = {
                         name = GetPlayerName(selected[1]) or "N/A",
                         id   = "N/A",
                         img  = false
                    }
               end

               local player2Data = exports["dmf-core"]:GetPlayerData(selected[2])
               local sourceDiscord = player2Data.discord
               if not sourceDiscord or next(sourceDiscord) == nil then
                    print(("Failed to get %s sourceDiscord"):format(selected[2]))
                    sourceDiscord = {
                         name = GetPlayerName(selected[2]) or "N/A",
                         id   = "N/A",
                         img  = false
                    }
               end

               Requests[matchId] = {
                    matchId    = matchId,
                    fromId     = selected[1],
                    sourceId   = selected[2],

                    matchData  = {
                         bet = 0,
                         rounds = 5,
                         weapon = "WEAPON_APPISTOL",
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

               TriggerClientEvent("mate-wagerv2->MatchFound", selected[1])
               TriggerClientEvent("mate-wagerv2->MatchFound", selected[2])
               Wait(800)
               TriggerEvent("mate-wagerv2:RequestAccepted", matchId, true)
               selected = {}
          end

          Wait(2000)
     end
end))


RegisterNetEvent('mate-wagerv2:ToggleMatchmake', function(state)
     local source = source



     if PlayersInGame[tostring(source)] then
          return
     end

     if type(state) == "boolean" then
          if state then
               goto allowMatchmake
          else
               Matchmake[tostring(source)] = nil
          end
          return
     end

     ::allowMatchmake::
     if Matchmake[tostring(source)] then
          Matchmake[tostring(source)] = nil
     end

     Matchmake[tostring(source)] = true
end)
