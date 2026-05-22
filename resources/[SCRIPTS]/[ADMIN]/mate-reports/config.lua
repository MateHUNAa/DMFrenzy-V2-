Config = {}
Config.Locale = "en"

Config.Webhook = exports["mCore"]:getHook() -- OR CHANGE YOUR OWN

Config.Notify = (function(playerId, title, message)
     TriggerClientEvent("codem-notification:Create", playerId, message, "info", title, 5000)
end)

Config.ReportLimit = 3

Messages = {}
Messages["Title"] = "[Report System]"
Messages["newReport"] = "New report found !"
Messages["reportSent"] = "Your help request was sent to administrators"

Messages["noOnlineAdmin"] = "Unfortunately no online administrators"

Messages["yourReportDeleted"] = "Your report has been deleted by %s"
Messages["reportDeleted"] = "You deleted a report !"


Messages["SameReportExists"] = "You already opened a report !"
Messages["limitReach"] = "You already opened 3 different report !"
Messages["reportClaimed"] = "Your report has been claimed !"


Config.RandomID = (function(length)
     local possibleCharacters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

     if not length or length == 0 then
          length = 6
     end

     local rID = ""

     for i = 1, length do
          local randomIndex = math.random(1, #possibleCharacters)

          rID = rID .. possibleCharacters:sub(randomIndex, randomIndex)
     end

     return rID
end)
