ESX = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


lib.callback.register("dmf-garage->GetOwnedVehicles", (function(source)
     local xPlayer = mCore.getXPlayer(source)
     local identifier = xPlayer.getIdentifier()

     local ownedVehicles = MySQL.query.await("SELECT * FROM `owned_vehicles` WHERE `owner` = ?", { identifier })


     print(json.encode(ownedVehicles, {
          indent = true
     }), identifier)

     return ownedVehicles
end))
