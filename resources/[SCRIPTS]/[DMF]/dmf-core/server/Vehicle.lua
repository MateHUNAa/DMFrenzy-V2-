lib.callback.register("dmf-core->CreateVehicle", (function(source, model)
     local myped        = GetPlayerPed(source)
     local mypos        = GetEntityCoords(myped)
     local myhed        = GetEntityHeading(myped)

     local isValidModel = lib.callback.await("mate-pedmenu->IsModelExist", source, model)
     if not isValidModel then
          print("Model not Exist !", model)
          return false
     end

     local vehId = CreateVehicle(model, mypos.x, mypos.y, mypos.z, myhed, true, true)
     local to = GetGameTimer() + 5000

     while not DoesEntityExist(vehId) and GetGameTimer() < to do
          Wait(255)
     end

     if not DoesEntityExist(vehId) then
          print("Failed to create the vehicle: ", model)
          return false, nil
     end

     local netId = NetworkGetNetworkIdFromEntity(vehId)

     return true, { netId = netId }
end))
