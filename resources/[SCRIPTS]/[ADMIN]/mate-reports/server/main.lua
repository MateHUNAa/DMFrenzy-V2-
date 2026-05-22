ESX           = exports['es_extended']:getSharedObject()

cachedReports = {}
cachedAdmins  = {}

RegisterNetEvent("mate-reports:s:recivedClaimeds", (function(index)
     Config.Notify(index["initiatorId"], Messages["Title"], Messages["reportClaimed"])
     for player, adminData in pairs(cachedAdmins) do
          TriggerClientEvent("mate-reports:c:updateClaimed", player, index["identifier"])
     end
end))


RegisterNetEvent('m-reports:s:getCachedReports', (function(source)
     local isAdmin = exports["mate-admin"]:isAdmin(source, false)
     Wait(150)
     if not isAdmin then return end

     local nums = 0
     for i, v in pairs(cachedReports) do
          nums = nums + 1
          local data = {
               PlayerName        = v["subject"],
               PlayerMessage     = v["description"],
               category          = v["category"],
               initiatorServerId = i,
               identifier        = v["identifier"]
          }

          local success, err = pcall(function()
               TriggerClientEvent("mate-report:reciveData", source, data)
          end)

          if not success then
               print("Error in TriggerClientEvent:", err)
          end

          Wait(150)
     end

     if nums > 0 then
          Config.Notify(source, Messages["Title"], ("Loaded %s cached reports !"):format(nums))
     end
end))


RegisterNetEvent("mate-reports:s:sendReport", (function(initiatorId, subject, description, category)
     local initiatorName = GetPlayerName(initiatorId)
     local adminsFound = 0
     local randomId = ""

     if not cachedReports[initiatorId] then
          cachedReports[initiatorId] = {}
     end

     if cachedReports[initiatorId]["subject"] == subject then
          return Config.Notify(initiatorId, Messages["Title"], Messages["SameReportExists"])
     end

     local random = Config.RandomID(3)

     randomId = ("%s-%s"):format(initiatorId, random)

     cachedReports[initiatorId] = {
          subject = subject,
          category = category,
          identifier = randomId,
          description = description
     }


     sendReportLogEmbed(initiatorName, initiatorId, subject, description, category)
     for player, adminData in pairs(cachedAdmins) do
          TriggerClientEvent("mate-report:reciveData", player, {
               PlayerName = (("%s < %s"):format(initiatorName, subject)),
               PlayerMessage = description,
               category = category,
               initiatorServerId = initiatorId,
               identifier = random
          })
          Config.Notify(player, Messages["Title"], Messages["newReport"])
          adminsFound = adminsFound + 1
     end

     if adminsFound == 0 then
          Config.Notify(initiatorId, Messages["Title"], Messages["noOnlineAdmin"])
     else
          Config.Notify(initiatorId, Messages["Title"], Messages["reportSent"])
     end
end))



ESX.RegisterServerCallback('mate-report:isAdmin', function(src, cb)
     local isAdmin = exports["mate-admin"]:isAdmin(src, true)
     Wait(150)
     cb(isAdmin)
     return isAdmin
end)

RegisterNetEvent("m-reports:s:deleteReport", function(data)
     local creatorId = data["id"]

     cachedReports[creatorId] = {}

     for playerId, adminData in pairs(cachedAdmins) do
          TriggerClientEvent("m-reports:c:deleteReport", playerId, data)

          if source then
               Config.Notify(source, Messages["Title"], Messages["reportDeleted"])
          end

          Config.Notify(creatorId, Messages["Title"], (Messages["yourReportDeleted"]):format(GetPlayerName(source)))
     end
end)



Citizen.CreateThread(function()
     Wait(250)
     while true do
          Wait(250)
          local newAdminList = exports["mate-admin"]:Administrators()

          print(json.encode(newAdminList, {
               indent = true
          }))
          for i, v in pairs(newAdminList) do
               if not cachedAdmins[i] then
                    cachedAdmins[i] = {}
               end
               cachedAdmins[i] = v
          end
          Citizen.Wait(30000)
     end
end)


RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
     local isAdmin = exports["mate-admin"]:isAdmin(player)
     if isAdmin then
          if not cachedAdmins[player] then
               cachedAdmins[player] = {}
          end
          cachedAdmins = {
               admin = true
          }
     end
end)

RegisterNetEvent('esx:playerDropped', function(playerId, reason)
     local isAdmin = exports["mate-admin"]:isAdmin(playerId)

     if isAdmin then
          if cachedAdmins[playerId] then
               cachedAdmins[playerId] = nil
          end
     end
end)


function sendReportLogEmbed(initiatorName, initiatorId, subject, description, category)
     local embed = {
          {
               ["color"] = embedColor,
               ["title"] = string.format("Report from %s (%s)", initiatorName, initiatorId),
               ["description"] = string.format("**Subject:** %s\n**Description:** %s\n**Category:** %s", subject,
                    description, category),
               ["footer"] = {
                    ["text"] = "Report Log - Made by MateHUN",
               },
               ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ"),
          }
     }

     exports['mCore']:sendEmbed(Config.Webhook, "Report Log", embed)
end
