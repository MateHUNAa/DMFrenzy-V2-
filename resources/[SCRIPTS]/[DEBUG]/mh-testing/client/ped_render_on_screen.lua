local clonedPed
local showPed = false
local zoom = false
RegisterCommand("mh:test", function()
     clonedPed = ClonePed(cache.ped, false, true, false)

     local positionBuffer = {}
     local bufferSize = 5


     showPed = not showPed

     while showPed do
          local screencoordsX = 0.46
          local screencoordsY = 0.7

          local world, normal = GetWorldCoordFromScreenCoord(screencoordsX, screencoordsY)
          local depth         =  6.0
          local target        = world + normal * depth
          local camRot        = GetGameplayCamRot(2)

          table.insert(positionBuffer, target)
          if #positionBuffer > 5 then
               table.remove(positionBuffer, 1)
          end

          local averagedTarget = vector3(0, 0, 0)
          for _, position in ipairs(positionBuffer) do
               averagedTarget = averagedTarget + position
          end
          averagedTarget = averagedTarget / #positionBuffer


          SetEntityCoords(clonedPed, averagedTarget.x, averagedTarget.y, averagedTarget.z, false, false, false, true)
          local heading_offset = 190.0
          SetEntityHeading(clonedPed, camRot.z + heading_offset)
          SetEntityRotation(clonedPed, camRot.x * (-1), 0.0, camRot.z + 170.0, 2, false)


          Wait(4)
     end
     DeleteEntity(ClonedPed)
     clonedPed = nil
end)


AddEventHandler("onResourceStop", (function(res)
     if GetCurrentResourceName() ~= res then return end

     if DoesEntityExist(clonedPed) then
          DeleteEntity(clonedPed)
     end

     FreezeEntityPosition(cache.ped, false)
end))
