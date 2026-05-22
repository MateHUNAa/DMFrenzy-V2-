ESX = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()
local inv = exports["ox_inventory"]

RegisterNetEvent('esx:setJob', function(player, job, oldJob)
     mCore.sendMessage(
          ("# ▶ 𝐉𝐨𝐛 𝐂𝐡𝐚𝐧𝐠𝐞𝐝\n```yaml\n- Player: %s (ID: %s)\n\n- Old Job: %s (`%s`)\n- New Job: %s (`%s`)\n```"):format(
               GetPlayerName(player), player,
               oldJob.label, oldJob.name,
               job.label, job.name
          ), mCore.RequestWebhook("setjob"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
end)


inv:registerHook("swapItems", (function(payload)
     local source   = payload.source
     local action   = payload.action
     local fromInv  = payload.fromInventory
     local toInv    = payload.toInventory
     local fromType = payload.fromType
     local toType   = payload.toType
     local count    = payload.count
     local fromSlot = payload.fromSlot
     local toSlot   = payload.toSlot

     local itemName = fromSlot.name
     local itemMeta = fromSlot.metadata

     local sameInv  = IsSameInventory(payload)

     local colors   = {
          ["move"]  = 16776960, -- yellow
          ["stack"] = 16753920, -- orange
          ["swap"]  = 255,      -- blue
          ["give"]  = 16711680, -- red
     }


     local message
     if action == "stack" then
          message = ("%s(%s) Stacked %s New count: %s in: [%s]"):format(GetPlayerName(source), source,
               toSlot.name,
               toSlot.count, sameInv and "SAME INVENTORY" or "DIFFERENT INVENTORY")
     end

     if action == "move" then
          if toType == 'drop' then
               local pos = GetEntityCoords(GetPlayerPed(source))
               message = ("%s(%s) Dropped %s[%s]```yaml\nvec3(%.2f,%.2f,%.2f)```"):format(
                    GetPlayerName(source), source,
                    itemName, count,
                    pos.x, pos.y, pos.z

               )
          end
     end

     local color = colors[action] or 16777215

     local embed = {
          {
               ["color"] = color or 255,
               ["title"] = "**Inventory Action: " .. action .. "**",
               ["description"] = message or " ",
               ["fields"] = {
                    {
                         ["name"] = "Source",
                         ["value"] = fromInv,
                         ["inline"] = true
                    },
                    {
                         ["name"] = "From Inventory",
                         ["value"] = fromInv,
                         ["inline"] = true
                    },
                    {
                         ["name"] = "From Type",
                         ["value"] = fromType,
                         ["inline"] = true
                    },
                    {
                         ["name"] = "To Inventory",
                         ["value"] = toInv,
                         ["inline"] = true
                    },
                    {
                         ["name"] = "To Type",
                         ["value"] = toType,
                         ["inline"] = true
                    },
                    {
                         ["name"] = "Item Count",
                         ["value"] = tostring(count) or "N/A",
                         ["inline"] = true
                    },
                    {
                         ["name"] = "Item Name",
                         ["value"] = itemName or "Unknown",
                         ["inline"] = true
                    },
                    -- {
                    --      ["name"] = "From Item Metadata",
                    --      ["value"] = json.encode(itemMeta, { indent = true }) or "None",
                    --      ["inline"] = true
                    -- },
               },
               ["footer"] = {
                    ["text"] = "Inventory Logger | Time: " .. os.date('%Y-%m-%d %H:%M:%S'),
               },
               ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ') -- ISO format timestamp
          }
     }

     local hook = mCore.RequestWebhook("inv_global")

     if action == "move" and toType == "drop" then
          hook = mCore.RequestWebhook("inv_drop")
     end

     if fromType == "player" and toType == "player" then
          hook = mCore.RequestWebhook("inv_give")
     end

     if toType == "stash" or fromType == "stash" then
          return
     end

     mCore.sendEmbed(embed, hook, ("mCore, %s"):format(GetCurrentResourceName()))
end))

inv:registerHook("swapItems", (function(payload)
     local stashbe = mCore.RequestWebhook("inv_stash")
     local stashki = mCore.RequestWebhook("inv_stash")

     local xPlayer = ESX.GetPlayerFromId(payload.source)


     if payload['fromType'] == "player" and payload["toType"] == "stash" then
          local embed = {
               {
                    ["title"] = ("%s:BE"):format(payload.toInventory),
                    ["thumbnail"] = {
                         ["url"] =
                         "https://cdn.discordapp.com/icons/1189019072818581706/379567727caccb99a4cc3514b1a1a9a9.png?size=1024"
                    },
                    ["color"] = 65280,
                    ["fields"] = {
                         {
                              ["name"] = "👤 Player",
                              ["value"] = payload.source and
                                  ("%s(%s)"):format(GetPlayerName(payload.source), payload.source) or
                                  "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = "💼 Job",
                              ["value"] = xPlayer.getJob() and
                                  ("%s(%s)"):format(xPlayer.getJob().name, xPlayer.getJob().grade) or "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = " ",
                              ["value"] = " ",
                              ["inline"] = false
                         },
                         -- Item
                         {
                              ["name"] = "👤 Item",
                              ["value"] = payload.fromSlot and payload.fromSlot.name or "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = "💼 Count",
                              ["value"] = payload.count or "N/A",
                              ["inline"] = true
                         },

                    },
                    ["footer"] = {
                         ["text"] = "MadeBy: mhScripts"
                    },
                    ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')

               }
          }
          mCore.sendEmbed(embed, stashbe, ("mCore, %s"):format(GetCurrentResourceName()))
     elseif payload['fromType'] == "stash" and payload["toType"] == "player" then
          local embed = {
               {
                    ["title"] = ("%s:KI"):format(payload.fromInventory),
                    ["thumbnail"] = {
                         ["url"] =
                         "https://cdn.discordapp.com/icons/1189019072818581706/379567727caccb99a4cc3514b1a1a9a9.png?size=1024"
                    },
                    ["color"] = 16776960,
                    ["fields"] = {
                         {
                              ["name"] = "👤 Player",
                              ["value"] = payload.source and
                                  ("%s(%s)"):format(GetPlayerName(payload.source), payload.source) or
                                  "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = "💼 Job",
                              ["value"] = xPlayer.getJob() and
                                  ("%s(%s)"):format(xPlayer.getJob().name, xPlayer.getJob().grade) or "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = " ",
                              ["value"] = " ",
                              ["inline"] = false
                         },
                         -- Item
                         {
                              ["name"] = "👤 Item",
                              ["value"] = payload.fromSlot and payload.fromSlot.name or "N/A",
                              ["inline"] = true
                         },
                         {
                              ["name"] = "💼 Count",
                              ["value"] = payload.count or "N/A",
                              ["inline"] = true
                         },

                    },
                    ["footer"] = {
                         ["text"] = "MadeBy: mhScripts"
                    },
                    ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')

               }
          }
          mCore.sendEmbed(embed, stashki, ("mCore, %s"):format(GetCurrentResourceName()))
     end
end))


AddEventHandler("onResourceStart", function(res)
     local desc = "Resource: " .. res
     local embed = {
          {
               ["color"] = 3066993,
               ["title"] = "**Resource Started**",
               ["description"] = desc,
               ["footer"] = {
                    ["text"] = "Resource Logger | Time: " .. os.date('%Y-%m-%d %H:%M:%S'),
               },
               ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
          }
     }
     mCore.sendEmbed(embed, mCore.RequestWebhook("resource"), ("mCore, %s"):format(GetCurrentResourceName()))
end)

AddEventHandler("onResourceStop", function(res)
     local embed = {
          {
               ["color"] = 15158332,
               ["title"] = "**Resource Stopped**",
               ["description"] = "Resource: " .. res,
               ["footer"] = {
                    ["text"] = "Resource Logger | Time: " .. os.date('%Y-%m-%d %H:%M:%S'),
               },
               ["timestamp"] = os.date('!%Y-%m-%dT%H:%M:%SZ')
          }
     }
     mCore.sendEmbed(embed, mCore.RequestWebhook("resource"), ("mCore, %s"):format(GetCurrentResourceName()))
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(player, isNew, skin)
     local xPlayer = mCore.getXPlayer(player)
     local source = xPlayer.source

     local playerData = nil
     if GetResourceState("dmf-core") == "started" then
          playerData = exports["dmf-core"]:GetPlayerData(xPlayer.source)
     end

     local desc = ""
     desc = desc .. "▶ **Account Details**\n"
     desc = desc .. "```yaml\n"
     desc = desc .. ("- Player ID: %s\n"):format(xPlayer.source)
     desc = desc .. ("- Identifier: %s\n"):format(xPlayer.identifier or "N/A")
     desc = desc .. ("- Name: %s\n"):format(GetPlayerName(xPlayer.source) or "Unknown")
     desc = desc .. "```\n\n\n"
     desc = desc .. "▶ **Player Informations**\n"
     desc = desc .. "```yaml\n"
     desc = desc .. ("- NewPlayer: %s"):format(isNew and "✅" or "❌")
     desc = desc .. ("- Job: %s\n- Grade: %s\n"):format(xPlayer.getJob().label, xPlayer.getJob().grade)
     desc = desc ..
         ("- Admin: %s\n- Group: %s\n"):format(exports["mate-admin"]:isAdmin(xPlayer.source) and "✅" or "❌",
              xPlayer.getGroup())
     if playerData then
          if playerData.playedTime then
               desc = desc ..
                   ("- PlayTime: %s"):format(formatPlayTime(playerData.playedTime.ms))
          end
     end
     desc = desc .. "```\n\n\n"


     local embed = {
          {
               ["color"] = 3066993, -- Discord green
               ["title"] = "✅ Player Connected",
               ["description"] = desc,
               ["footer"] = {
                    ["text"] = os.date("Connected at %Y-%m-%d %H:%M:%S")
               }
          }
     }

     mCore.sendEmbed(embed, mCore.RequestWebhook("join"), ("mCore, %s"):format(GetCurrentResourceName()))
end)


AddEventHandler('playerDropped', function(reason)
     local src = source
     local xPlayer = ESX.GetPlayerFromId(src)
     if not xPlayer then return end

     local playerData = nil
     if GetResourceState("dmf-core") == "started" then
          playerData = exports["dmf-core"]:GetPlayerData(src)
     end

     local desc = ""
     desc = desc .. "▶ **Account Details**\n"
     desc = desc .. "```yaml\n"
     desc = desc .. ("- Player ID: %s\n"):format(src)
     desc = desc .. ("- Identifier: %s\n"):format(xPlayer.identifier or "N/A")
     desc = desc .. ("- Name: %s\n"):format(GetPlayerName(src) or "Unknown")
     desc = desc .. "```\n\n\n"

     desc = desc .. "▶ **Player Informations**\n"
     desc = desc .. "```yaml\n"
     desc = desc .. ("- Job: %s, Grade: %s\n"):format(xPlayer.getJob().label, xPlayer.getJob().grade)
     desc = desc .. ("- Admin: %s, Group: %s\n"):format(exports["mate-admin"]:isAdmin(src), xPlayer.getGroup())
     if playerData and playerData.playedTime then
          desc = desc .. ("- PlayTime: %s\n"):format(formatPlayTime(playerData.playedTime.ms))
     end
     desc = desc .. "```\n\n\n"

     desc = desc .. "\n▶ **Disconnect Reason**\n"
     desc = desc .. ("`%s`"):format(reason or "Unknown")

     local embed = {
          {
               ["color"] = 16753920, -- Yellow
               ["title"] = "🚪 Player Disconnected",
               ["description"] = desc,
               ["footer"] = {
                    ["text"] = os.date("Disconnected at %Y-%m-%d %H:%M:%S")
               }
          }
     }

     mCore.sendEmbed(embed, mCore.RequestWebhook("leave"), ("mCore, %s"):format(GetCurrentResourceName()))
end)



function IsSameInventory(payload)
     return payload.fromType == "player" and payload.toType == "player" and
         payload.fromInv == payload.toInv and
         payload.fromInv == payload.source
end

function formatPlayTime(ms)
     local totalSeconds = math.floor(ms / 1000)
     local hours = math.floor(totalSeconds / 3600)
     local minutes = math.floor((totalSeconds % 3600) / 60)
     local seconds = totalSeconds % 60
     return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

-- AddEventHandler("esx:onAddInventoryItem", (function(source, item, count)
--      print(source, item, count)
-- end))

-- AddEventHandler("esx:onRemoveInventoryItem", (function(source, item, count)
--      print(source, item, count)
-- end))


RegisterNetEvent('dmf-log->AddItem', function()
     print("a")
end)
AddEventHandler("dmf-log->AddItem", (function(source, target, item, count)
     print("b")
     print(source, target, item, count)
end))
AddEventHandler("dmf-log->RemoveItem", (function(source, target, item, count)
     print(source, target, item, count)
end))
