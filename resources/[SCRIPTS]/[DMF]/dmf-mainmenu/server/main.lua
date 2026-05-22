ESX               = exports['es_extended']:getSharedObject()
mCore             = exports["mCore"]:getSharedObj()
local lang        = Loc[Config.lan]

local Gamemodes   = {}
local PlayersInGM = {}

lib.callback.register("dmf-mainmenu->GetDat", (function(src)
     return Gamemodes
end))

Citizen.CreateThread(function()
     for _, gameModeData in pairs(Config.Gamemodes) do
          Gamemodes[gameModeData.id]  = {}
          gameModeData.currentPlayers = 0

          Gamemodes[gameModeData.id]  = gameModeData
          exports["mate-dimManager"]:Create(gameModeData.id, "DMF", gameModeData.dimensionRules)
     end
end)

--
-- Events
--

RegisterNetEvent('esx:playerDropped', function(reason)
     RemovePlayerFromGM(source)
end)


--
-- Functions
--

RemovePlayerFromGM = (function(playerId)
     local plyGM = PlayersInGM[playerId]
     if not plyGM then return end

     local success = exports["mate-dimManager"]:RemovePlayer(playerId, plyGM.gamemode, "DMF")

     if not success then
          mCore.Notify(playerId, lang.Title, string.format(lang.error["SWW"], lang.info["leaveing"]), "type", duration)
          print(("Error occured while leaveing %s(%s) from gamemode %s(%s) "):format(GetPlayerName(playerId), playerId),
               plyGM.gamemode, plyGM.mode)

          mCore.sendMessage(
               ("Error occured while leaveing %s(%s) from gamemode %s(%s)"):format(GetPlayerName(playerId), playerId,
                    plyGM.gamemode, plyGM.mode), mCore.RequestWebhook("error"),
               ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
          return
     end

     PlayersInGM[playerId] = nil
     TriggerEvent("dmf-core->SelfDim")
     local players, NumOfPlayers = exports["mate-dimManager"]:GetPlayersInBucket(gamemode, "DMF")



     TriggerClientEvent("dmf-mainmenu->Update", -1, {
          gamemode = plyGM.gamemode,
          mode = plyGM.mode,
          playerCount = NumOfPlayers - 1
     })

     Wait(200)
     TriggerClientEvent("dmf-mainmenu->OpenMainMenu", playerId)
end)
exports("Leave", RemovePlayerFromGM)

---@param pid number
---@return boolean,string?,string?
IsPlayerInGamemode = (function(pid)
     local gmData = PlayersInGM[pid]

     if not gmData then
          return false
     end

     return true, gmData.gamemode, "DMF"
end)
exports("GetPlayerGameMode", IsPlayerInGamemode)

--
-- Callbacks
--

---@return boolean,string?,string?
lib.callback.register("dmf-mainmenu->IsPlayerInGamemode", (function(pid)
     return IsPlayerInGamemode(pid)
end))

---@param source number
---@param data { gamemdoe: string, mode: string }
---@return boolean
lib.callback.register("dmf-mainmenu->JoinMode", (function(source, data)
     local src = source

     mCore.debug.log("[JoinMode]-> Data ->", data, json.encode(data, { indent = true }))

     local inGame, _gm, _mode = IsPlayerInGamemode(src)

     if inGame then
          RemovePlayerFromGM(src)
          mCore.debug.log("Player removed from old gamemode!")
     end

     ---@diagnostic disable-next-line: undefined-field
     local gamemode = data.gamemode

     if not Gamemodes[gamemode] then
          mCore.Notify(src, lang.Title, lang.error["no_gamemode"], "error", 5000)
          mCore.error(("%s(%s) Tried to connect to GameMode witch is not exist! GM: %s"):format(GetPlayerName(src), src,
               gamemode))
          return false
     end

     local gmData = Gamemodes[gamemode]

     local players, NumOfPlayers = exports["mate-dimManager"]:GetPlayersInBucket(gamemode, "DMF")

     if NumOfPlayers >= gmData.maxPlayers then
          mCore.Notify(src, lang.Title, lang.error["gm_full"], "error", 5000)
          return false
     end

     exports["mate-dimManager"]:AddPlayer(src, gamemode, "DMF")

     PlayersInGM[src] = { gamemode = gamemode }

     mCore.Notify(src, lang.Title, string.format(lang.success["connect"], gamemode), "success", 5000)
     TriggerClientEvent('dmf-mainmenu->Update', -1, {
          gamemode    = gamemode,
          mode        = mode,
          playerCount = NumOfPlayers + 1
     })

     return true
end))

lib.callback.register("dmf-mainmenu->GetPlayerCount", (function(src, gamemode)
     local players, NumOfPlayers = exports["mate-dimManager"]:GetPlayersInBucket(gamemode, "DMF")
     return NumOfPlayers
end))

RegisterNetEvent('dmf-mainmenu->Leave', function()
     local source = source
     RemovePlayerFromGM(source)
end)
