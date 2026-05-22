local defaultVehicle = "akuma"
RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
     print("esx:playerLoaded ", player, isNew)
     if not isNew then return end

     if not Config.StarterItems or next(Config.StarterItems) == nil then return print("FATAL: No StarterItems ") end

     Wait(5000)

     local time = os.date("%Y:%m:%d %H:%M")

     for itemName, count in pairs(Config.StarterItems) do
          local itemMeta = {
               description = ("STARTER %s"):format(time),
          }


          if itemName == "vehicle" then
               itemMeta = {
                    label = Shared.CapitalizeFirstLetter(defaultVehicle),
                    model = defaultVehicle,
                    image = string.lower(defaultVehicle)
               }
          end

          local s, r = exports.ox_inventory:AddItem(player, itemName, count, itemMeta)
          if not s then print(r) end
          print(("ADDING:  starter item : %s[%s]\nWithMeta: %s"):format(itemName, count,
               json.encode(itemMeta, { indent = true })))
     end
end)
