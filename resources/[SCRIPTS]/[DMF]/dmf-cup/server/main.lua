ESX               = exports['es_extended']:getSharedObject()
mCore             = exports["mCore"]:getSharedObj()

local dim         = exports["mate-dimManager"]
local Games       = {}
local PlayerTeams = {}
local activeGames = {}


local isTeamExist = (function(teamName)
     local found = MySQL.scalar.await("SELECT COUNT(*) FROM dmf_cup WHERE teamName = ?", { teamName })

     return found > 0
end)

local getTeamData = (function(teamName)
     local data = MySQL.single.await("SELECT * FROM dmf_cup WHERE teamName = ?", { teamName })
     return data
end)


Citizen.CreateThread((function()
     dim:Create("dmf-cup", "dmf", {
          ["DenyRespawn"] = true
     })
end))

---@param data {team1: string, team2: string}
RegisterNetEvent('dmf-cup->InitiateCup', function(data)
     local source = source
     if not isTeamExist(data.team1) then
          return mCore.Notify(source, "[DMF Cup]", ("Team not exist with name %s"):format(data.team1), "error", 5000)
     end

     if not isTeamExist(data.team2) then
          return mCore.Notify(source, "[DMF Cup]", ("Team not exist with name %s"):format(data.team2), "error", 5000)
     end

     local team1 = getTeamData(data.team1) ---@as {teamName:string, user1: string, user2: string}
     local team2 = getTeamData(data.team2) ---@as {teamName:string, user1: string, user2: string}
     -- print("Team1\n", json.encode(team1, { indent = true }), "\n\nTeam2\n", json.encode(team2, { indent = true }))


     local Players = {}
     local team1Players = {}
     local team2Players = {}

     local foundPlayers = 0
     for i, pid in pairs(GetPlayers()) do
          local discordId = GetPlayerIdentifierByType(pid, "discord"):sub(9)

          if discordId == team1.user1 then
               team1Players["user1"] = {
                    id = pid,
                    did = discordId
               }
               foundPlayers += 1
          end

          if discordId == team1.user2 then
               team1Players["user2"] = {
                    id  = pid,
                    did = discordId
               }
               foundPlayers += 1
          end


          if discordId == team2.user1 then
               team2Players["user1"] = {
                    id = pid,
                    did = discordId
               }
               foundPlayers += 1
          end

          if discordId == team2.user2 then
               team2Players["user2"] = {
                    id = pid,
                    did = discordId
               }
               foundPlayers += 1
          end
     end

     table.insert(Players, team1Players)
     table.insert(Players, team2Players)

     print("Players >", json.encode(Players, { indent = true }))

     if foundPlayers ~= 4 then
          print(("foundPlayers == %s || T1: %s || T2: %s"):format(foundPlayers, #team1Players, #team2Players))
     end

     local c_t1 = 0
     local c_t2 = 0
     for i, v in pairs(Players[1]) do
          c_t1 += 1
     end
     for i, v in pairs(Players[1]) do
          c_t2 += 1
     end

     print(c_t1, c_t2)

     if c_t1 < 2 then
          return mCore.Notify(source, "[DMF Cup]", "One or both player in `Team 1` is offline ! ", "error", 5000)
     end
     if c_t2 < 2 then
          return mCore.Notify(source, "[DMF Cup]", "One or both player in `Team 2` is offline ! ", "error", 5000)
     end


     for i, teams in pairs(Players) do
          local count = 1
          for _, player in pairs(teams) do
               count += 1

               dim:AddPlayer(player.id, "dmf-cup", "dmf")

               Wait(200)

               local ped = GetPlayerPed(player.id)
               SetEntityCoords(ped, Config.positions[i].x + (.5 * count), Config.positions[i].y + (.65 * count),
                    Config.positions[i].z, true,
                    false, false, false)
               SetEntityHeading(ped, Config.positions[i].w)
               lib.callback.await("dmf-cup->SetInvicibility", player.id, true)
               FreezeEntityPosition(ped, true)
          end
     end
end)


---@param data {team1: string, team2: string}

RegisterNetEvent('dmf-cup:StartGame', function(data)
     local source = source
     if not isTeamExist(data.team1) then
          return mCore.Notify(source, "[DMF Cup]", ("Team not exist with name %s"):format(data.team1), "error", 5000)
     end

     if not isTeamExist(data.team2) then
          return mCore.Notify(source, "[DMF Cup]", ("Team not exist with name %s"):format(data.team2), "error", 5000)
     end

     local team1 = getTeamData(data.team1) ---@as {teamName:string, user1: string, user2: string}
     local team2 = getTeamData(data.team2) ---@as {teamName:string, user1: string, user2: string}


     activeGames[tostring(team1.teamName)] = true
     activeGames[tostring(team2.teamName)] = true

     local Players = {}
     local team1Players = {}
     local team2Players = {}

     local foundPlayers = 0
     for i, pid in pairs(GetPlayers()) do
          local discordId = GetPlayerIdentifierByType(pid, "discord"):sub(9)

          if discordId == team1.user1 then
               team1Players["user1"] = {
                    id = pid,
                    did = discordId,
                    teamName = team1.teamName
               }
               foundPlayers += 1
          end

          if discordId == team1.user2 then
               team1Players["user2"] = {
                    id       = pid,
                    did      = discordId,
                    teamName = team1.teamName
               }
               foundPlayers += 1
          end


          if discordId == team2.user1 then
               team2Players["user1"] = {
                    id = pid,
                    did = discordId,
                    teamName = team2.teamName
               }
               foundPlayers += 1
          end

          if discordId == team2.user2 then
               team2Players["user2"] = {
                    id = pid,
                    did = discordId,
                    teamName = team2.teamName

               }
               foundPlayers += 1
          end
     end

     table.insert(Players, team1Players)
     table.insert(Players, team2Players)

     Games[tostring(team1.teamName) .. "-" .. tostring(team2.teamName)] = Players


     for i, teams in pairs(Players) do
          for _, player in pairs(teams) do
               print('teams>player>', json.encode(player))
               PlayerTeams[tostring(player.id)] = player.teamName
               local ped = GetPlayerPed(player.id)
               lib.callback.await("dmf-cup->SetInvicibility", player.id, false)
               FreezeEntityPosition(ped, false)
          end
     end
end)


local kills = {}
local scores = {}
AddEventHandler("mate-kd:onKill", (function(killer, victim)
     local killerTeam = PlayerTeams[tostring(killer.sourceId)]
     local victimTeam = PlayerTeams[tostring(victim.sourceId)]

     if not activeGames[tostring(killerTeam)] or not activeGames[tostring(victimTeam)] then
          return
     end

     if not kills[tostring(killerTeam)] then
          kills[tostring(killerTeam)] = 0
     end

     if killerTeam == victimTeam then
          kills[tostring(victimTeam)] += 1
          return print("Team KILL ! No points")
     end

     local game = Games[tostring(killerTeam) .. "-" .. tostring(victimTeam)]

     if not game then game = Games[tostring(victimTeam) .. "-" .. tostring(killerTeam)] end
     if not game then
          return print(("FAT: No game found with ids; [%s] - [%s]"):format(
               (tostring(killerTeam) .. "-" .. tostring(victimTeam)),
               (tostring(victimTeam) .. "-" .. tostring(killerTeam))))
     end


     kills[tostring(killerTeam)] += 1


     local function TeleportTeam(team, i)
          local c = 0
          for _, player in pairs(team) do
               c += 1
               local ped = GetPlayerPed(player.id)

               SetEntityCoords(ped, Config.positions[i].x + (0.6 * c), Config.positions[i].y + (0.6 * c),
                    Config.positions[i].z, true, false,
                    false, false)
               FreezeEntityPosition(ped, true)
               TriggerClientEvent('dmf-spawnmanager->Revive', player.id,
                    vec3(Config.positions[i].x + (0.6 * c), Config.positions[i].y + (0.6 * c),
                         Config.positions[i].z))

               lib.callback.await("dmf-cup->SetInvicibility", player.id, true)
               TriggerClientEvent("dmf-cup->Countdown", player.id)
               Citizen.CreateThread((function()
                    Wait(5000)
                    lib.callback.await("dmf-cup->SetInvicibility", player.id, false)
                    FreezeEntityPosition(ped, false)
               end))
          end
     end


     if kills[tostring(killerTeam)] >= 2 then
          print("Round over WINNER: ", killerTeam)

          if not scores[tostring(killerTeam)] then
               scores[tostring(killerTeam)] = 0
          end

          scores[tostring(killerTeam)] += 1

          -- WinCon?
          if scores[tostring(killerTeam)] >= 3 then
               print(("%s WON THE CUP !"):format(killerTeam))
               activeGames[tostring(killerTeam)] = false
               activeGames[tostring(victimTeam)] = false

               for _, player in pairs(game[1]) do
                    print(player.id)

                    TriggerClientEvent('dmf-spawnmanager->Revive', player.id,
                         vec3(Config.Spawnpos.x, Config.Spawnpos.y, Config.Spawnpos.z))
                    lib.callback.await("dmf-cup->SetInvicibility", player.id, false)

                    dim:RemovePlayer(player.id, "dmf-cup", "dmf")
                    Wait(100)
                    TriggerClientEvent('dmf-cup->END', player.id)
               end

               for _, player in pairs(game[2]) do
                    print(player.id)

                    TriggerClientEvent('dmf-spawnmanager->Revive', player.id,
                         vec3(Config.Spawnpos.x, Config.Spawnpos.y, Config.Spawnpos.z))
                    lib.callback.await("dmf-cup->SetInvicibility", player.id, false)


                    dim:RemovePlayer(player.id, "dmf-cup", "dmf")
                    Wait(100)
                    TriggerClientEvent('dmf-cup->END', player.id)
               end

               Wait(500)

               -- Return Player inventory
          else
               TeleportTeam(game[1], 1)
               TeleportTeam(game[2], 2)
          end


          kills[tostring(killerTeam)] = 0
          kills[tostring(victimTeam)] = 0
     end
end))
