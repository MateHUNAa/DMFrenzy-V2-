Config = {}
ESX    = exports['es_extended']:getSharedObject()

mCore  = nil
Citizen.CreateThread(function()
     while not mCore do
          Wait(1500)
          mCore = TriggerEvent("mCore:getSharedObj")
     end
end)

Config.LicenseKey          = "matehun-4ctsgZQbiSLEnvEa3ct5SPvq6pbfcx2xL8UfdH77iCPljx9"

Config.HealOnKill          = true
Config.ArmourOnKill        = true
Config.ToggleDistanceMoney = false
Config.IncludeAI           = true -- Experimental

Config.FactionKD           = true

Config.ToggleUiKey         = "F4"

Config.DisplaySettings     = {
     kills      = true,
     deaths     = true,
     kd         = true, -- Kills / Deaths
     hsr        = true, -- Kills / Headshots
     money      = false,
     serverName = false
}

Config.ToggleDiscordLog    = true
Config.DiscordSystemName   = "KD - LOG"


Config.notify = {
     ["default"] = "%s killed!",
}

--
-- Handle your own stuff here ( Server Side )
--

Config.onKill = function(killer, victim, headshot, killStreak)
     handleOnKillMoney(killer, victim, headshot, killStreak)
     handleRobber(killer, victim)
     -- handleHarvest(killer, victim) -- rime-drugsystem
end

local lastKill = {}

function handleOnKillMoney(killer, victim, headshot, killStreak)
     if not killer or not victim then return end

     local xPlayer = ESX.GetPlayerFromId(killer)
     local count = 1

     -- if headshot then count = 3 end

     -- if not killStreak then killStreak = 1 end


     -- count += killStreak

     xPlayer.addInventoryItem("money", count)

     Log(
          ("%s(%s) got %s money for killing %s %s"):format(
          GetPlayerName(killer), killer,
               math.floor(count),
               GetPlayerName(victim), victim), "money")
end

function handleHarvest(killer, victim)
     local sb = Player(victim).state
     local isVictimHarvest = sb["m-harvest:geathering"]

     if not isVictimHarvest then return end

     local id = sb["m-harvest:zoneId"]

     TriggerClientEvent("mate-harvest:killBlip", victim, id)

     local victimInv = exports.ox_inventory:GetInventoryItems(victim)

     for i, v in pairs(victimInv) do
          if v.name == "speed" then
               local count = math.floor((v.count / 3))
               local s = exports["ox_inventory"]:RemoveItem(victim, "speed", count)
               if s then
                    mCore.debug.log(("Removed %s speed from %s(%s)"):format(count, GetPlayerName(victim), victim))
                    local su, r = exports["ox_inventory"]:AddItem(killer, "speed", count)
                    if su then
                         mCore.debug.log(("Givven %s speed to %s(%s) for killing %s(%s)"):format(count,
                              GetPlayerName(killer), killer, GetPlayerName(victim), victim))

                         local webhook = Config.Webhook
                         mCore.sendMessage(
                              ("**%s(%s)** got %s **speed** for killing **%s(%s)**"):format(GetPlayerName(killer), killer,
                                   count,
                                   GetPlayerName(victim), victim), webhook, "HARVEST - onKill")
                    else
                         Citizen.Trace(("Error while adding speed to %s(%s)\nRes: %s"):format(GetPlayerName(killer),
                              killer, r))
                    end
               end
               break
          end
          print(i, json.encode(v))
     end
end

function handleRobber(killer, victim)
     local isRobber = Player(victim).state.robber
     local xPlayer  = ESX.GetPlayerFromId(killer)
     local reward   = 1

     if killer == victim then return nil end
     if isRobber then
          xPlayer.addInventoryItem("money", reward)
          Player(victim).state:set("robber", false)

          Log(("%s(%s) got %s for killed a robber %s(%s)"):format(GetPlayerName(killer), killer, reward,
               GetPlayerName(victim), vicitim), "money")
          return
     end
end

Config.onSuicide = (function(victim)

end)


Config.onNpcKilled = (function(killer, headshot)
end)


-- Killfeed

Config.IncludeAI           = true
Config.AddAIPrefix         = true
Config.AIPrefix            = "[NPC] "
Config.UseRandomAINames    = true

Config.IncludeAnimals      = false
Config.AddAnimalPrefix     = false
Config.AnimalPrefix        = "[UNDEFINED] "
Config.AddAnimalSuffix     = true

Config.KillerColour        = {
     Player = { r = 255, g = 165, b = 0 },
     NPC    = { r = 125, g = 160, b = 215 },
}
Config.VictimColour        = {
     Player = { r = 219, g = 66, b = 66 },
     NPC    = { r = 219, g = 66, b = 66 },
}

Config.ShowTime            = 8000
Config.MaxLines            = 7

Config.DisplayHeadshots    = true
Config.DisplayNoScopes     = true
Config.DisplayDriveByIcons = true
















--
-- Embed mode (Experimental Only)
--

Config.ToggleDiscordEmbed = false
Config.KillEmbed = {
     {
          ['color'] = 16753920,
          ["title"] = "**KD System**",
          ["description"] = "%s Killed by %s",
          ["fields"] = {
               { ["name"] = "%s KD", ["value"] = "%s " },
               { ["name"] = "%s KD", ["value"] = "%s" },
          }

     }
}

Config.TestMode = false -- /testEmbed
Config.TestEmbed = {
     {

          ['color'] = 16753920,
          ["title"] = "**" .. "KD System" .. "**",
          ["description"] = "%s Killed by %s",
          ["fields"] = {
               { ["name"] = "%s KD", ["value"] = "%s " },
               { ["name"] = "%s KD", ["value"] = "%s" },
          }

     }
}
