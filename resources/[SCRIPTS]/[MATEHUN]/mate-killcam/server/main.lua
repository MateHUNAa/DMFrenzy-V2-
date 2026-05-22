ESX = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


lib.callback.register("fenix-killcam->RequsetKillerData", (function(source)
     local xPlayer = ESX.GetPlayerFromId(source)
     local idf = xPlayer.getIdentifier()

     local row = MySQL.single.await(
          "SELECT kills,deaths,discordid,player_name,rang FROM `mate-kd` WHERE identifier = ?", { idf })

     return {
          discordName = row["player_name"],
          discordId = row["discordid"],

          kills = row["kills"],
          deaths = row["deaths"],

          rank = row["rang"]
     }
end))
