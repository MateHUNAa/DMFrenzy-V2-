ESX                  = exports['es_extended']:getSharedObject()
mCore                = exports["mCore"]:getSharedObj()
local lang           = Loc[Config.lan]
Robbers              = {}

local inv            = exports["ox_inventory"]
local activeRobs     = 0
local activeRobberys = {}

local Cooldown       = {
     ['Shop']   = {},
     ["Bank"]   = {},
     ["House"]  = {},
     ["Police"] = {},
     ["debug"]  = {},
}



lib.callback.register("shoprob->OnCooldown", (function(source, shopID, type)
     local new = false

     local errNum = nil

     if #GetPlayers() < (Config.Shops[type].minPlayer or 7) then
          mCore.Notify(source, lang.Title,
               (string.format(lang.error["not_enough_players"], Config.Shops[type].minPlayer or 1)), "error", 5000)
          return false, false
     end

     if not Cooldown[type][shopID] then
          Cooldown[type][shopID] = GetGameTimer()
          new                    = true

          print(shopID, ("New store?, typ: %s"):format(type))
     end

     local state = Player(source).state

     state:set("robber", true, true)


     local elapsedTime       = GetGameTimer() - Cooldown[type][shopID]
     local totalTimeRequired = Config.Shops[type].Cooldown + Config.Shops[type].RestoreTime
     local remainingTime     = math.max(0, totalTimeRequired - elapsedTime)

     local allow             = new and true or (elapsedTime >= totalTimeRequired)

     if activeRobs >= Config.MaxRobs then
          allow = false
          errNum = 1 -- 1=Limit reach
     end

     if allow then
          activeRobs += 1
          activeRobberys[shopID] = {
               type = type,
               id   = shopID
          }
          Robbers[tostring(source)] = shopID
     end

     return allow, remainingTime, errNum
end))


RegisterNetEvent("shoprob->Failed", (function(shopId)
     local source = source
     local state = Player(source).state
     state:set("robber", false, true)

     print(("%s(%s) Failed to rob %s"):format(GetPlayerName(source), source, shopId))

     TriggerClientEvent("shoprob->RemoveBlips", -1, shopId)
     activeRobs -= 1
     activeRobberys[shopId] = false
     if Robbers[tostring(source)] then
          Robbers[tostring(source)] = nil
     else
          print(("[Err] %s(%s) failed a robbery but not in robbers !"):format(GetPlayerName(source), source))
     end
end))

RegisterNetEvent('shoprob->Complete', function(type, shopId)
     local source = source
     mCore.Notify(-1, lang.Title, lang.info[type .. "_" .. "Complete"], "info", 5000)

     local state = Player(source).state
     state:set("robber", false, true)

     TriggerClientEvent("shoprob->RemoveBlips", -1, shopId)
     activeRobs -= 1
     activeRobberys[shopId] = false

     if Robbers[tostring(source)] then
          Robbers[tostring(source)] = nil
     else
          print(("[Err] %s(%s) Competed a robbery but not in robbers !"):format(GetPlayerName(source), source))
     end

     if (GetGameTimer() - Cooldown[type][shopId]) >= Config.Shops[type].Cooldown then
          math.randomseed(GetGameTimer())

          local reward = math.random(Config.Shops[type].Reward.min, Config.Shops[type].Reward.max) *
              (Config.useMultiplier and Config.Multiplier or 1)

          local s, res = inv:AddItem(source, "money", reward)
          if not s then print(res) end



          mCore.sendMessage(("%s[%s] Robbed a `%s` stole: `%s` at: %s"):format(
               GetPlayerName(source), source,
               type, reward, os.date("%Y-%m-%d, %H:%M")
          ), mCore.RequestWebhook("money"), ("mCore, %s-Rob"):format(type))
     end
end)


RegisterNetEvent('shoprob->DisplayBlip', function(shopId, coords)
     TriggerClientEvent("shoprob->CreateActiveBlip", -1, coords, shopId)
end)



RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
     Wait(5000)
     for _, data in pairs(activeRobberys) do
          if type(data) == "table" then
               local index = string.sub(data.id, -1)
               TriggerClientEvent("shoprob->CreateActiveBlip", player,
                    Config.Shops[data.type].coords[tonumber(index)].xyz,
                    data.id)
          end
     end
end)

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
     if Robbers[tostring(playerId)] then
          activeRobberys[Robbers[tostring(playerId)]] = false
          TriggerClientEvent("shoprob->RemoveBlips", -1, Robbers[tostring(playerId)])
          mCore.Notify(-1, "[DMF Robbery]", ("%s(%s) Left during a robbery !"):format(GetPlayerName(playerId), playerId),
               "info", 3000)
          Robbers[tostring(playerId)] = nil
     end
end)



--
-- Debug Commands
--

RegisterCommand("robbery:getActive", function(source, args, raw)
     local isAdmin = exports["mate-admin"]:isAdmin(soruce, true)

     if not isAdmin then return end

     print("ActiveRobberys: ", json.encode(activeRobberys, { indent = true }))
end, false)
