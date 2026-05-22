local inv = exports["ox_inventory"]


inv:registerHook("buyItem", (function(payload)
     if payload.itemName ~= "vehicle" then
          return true
     end

     local ret = inv:Search(payload.toInventory, "count", payload.itemName)
     if ret and ret > 0 then return false end

     return true
end))


lib.callback.register("dmf-core->[G]Vehicle", (function(source, model, label)
     local ret = inv:Search(source, "count", "vehicle")
     if ret and ret > 0 then return false end

     local found = false
     for i, v in pairs(Config.FreeVehicles) do
          if GetHashKey(v) == model then
               found = true
               break
          end
     end

     if found then
          inv:AddItem(source, "vehicle", 1, {
               model = model,
               label = Shared.CapitalizeFirstLetter(label),
               image = tostring(string.lower(label)),
          })
     end
end))


lib.callback.register("dmf-core->SavePlayerTime", (function(source, count)
     inv:AddItem(source, "money", count)
end))


-- Change Weapon Durability
RegisterNetEvent('dmf-core->CWPCAMODUR', function(loadedRounds)
     local source = source
     local currentWeapon = exports.ox_inventory:GetCurrentWeapon(source)

     if not currentWeapon then
          return print(("^1Failed to set the weapon durability for Player: %s(%s)"):format(
          GetPlayerName(source), source))
     end

     if Config.DurabilityBlackList[currentWeapon.name] then
          return
     end

     exports.ox_inventory:SetDurability(source, currentWeapon.slot,
          currentWeapon.metadata.durability - (loadedRounds * 0.1))
end)


lib.callback.register("dmf->SellWeapon", (function(source, weapon, price, i)
     local invoke = GetInvokingResource()
     print("Invoke: ", invoke, i)
     if not invoke then
          invoke = i
     end

     if invoke ~= "mate-npcv2" then
          exports["esx_society"]:fg_BanPlayer(source,
               ("Possible exploiting (TriggerEvent), Event: `dmf->SellWeapon` weapon: %s price: %s"):format(weapon, price),
               true)
          mCore.sendMessage(
               ("Exploit detection (TriggerEvent), Event: **`dmf->SellWeapon`**, Player: **%s(%s)**"):format(
                    GetPlayerName(source), source
               ), mCore.RequestWebhook("exploit"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
          return false
     end

     if not price then
          price = 5
     end

     if price >= 150 then
          exports["esx_society"]:fg_BanPlayer(source,
               ("Possible exploiting Overwritting price ! Event: (dmf->SellWeapon) tried to sell weapon: %s for price: %s")
               :format(weapon, price),
               true)
          mCore.sendMessage(
               ("Possible exploiting **%s(%s)** Tried to Overwrite item sell price: Event: **(dmf->SellWeapon)**, Tried to sell weapon: **%s** for price **%s**")
               :format(
                    GetPlayerName(source), source,
                    weapon, price
               ), webhook, ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
          return false
     end

     local s, res = inv:RemoveItem(source, weapon, 1)

     if s then
          local _s = inv:AddItem(source, "money", price)
          mCore.sendMessage(("**%s(%s)** Sold a weapon: **%s** for price **%s**"):format(
               GetPlayerName(source), source,
               weapon,
               price
          ), mCore.RequestWebhook("money"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))

          if _s then
               return true
          end
     else
          mCore.sendMessage(("**%s(%s)** Failed to sell weapon: **%s** for price: **%s** Reason: **`%s`**"):format(
               GetPlayerName(source), source,
               weapon,
               price,
               res
          ), mCore.RequestWebhook("error"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))
          return false
     end
end))
