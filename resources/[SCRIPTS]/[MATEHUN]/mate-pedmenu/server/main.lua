ESX        = exports['es_extended']:getSharedObject()
mCore      = exports["mCore"]:getSharedObj()
local lang = Loc[Config.lan]

Citizen.CreateThread((function()
     local table = {
          "`identifier` varchar(50) DEFAULT NULL",
          "`ped` varchar(50) DEFAULT NULL",
     }

     mCore.createSQLTable("mate-peds", table)
end))

lib.callback.register("mate-pedmenu->RequestPeds", (function(source)
     local idf = GetPlayerIdentifierByType(source, "license"):sub(9)

     local res = MySQL.query.await('SELECT ped FROM `mate-peds` WHERE identifier = ?', { idf })

     local peds = {}


     if Config.DefaultPeds and next(Config.DefaultPeds) ~= nil then
          for i, v in pairs(Config.DefaultPeds) do
               table.insert(peds, v)
          end
     end


     if GetResourceState("mate-vipsystem") == "started" then
          local isVip, Level = exports["mate-vipsystem"]:GetPlayerVIPLevel(source)

          if not isVip then goto continue end

          if Config.VIPPeds and next(Config.VIPPeds) ~= nil then
               for i, v in pairs(Config.VIPPeds) do
                    if Level >= v.minVip then
                         table.insert(peds, v.ped)
                    end
               end
          end

          ::continue::
     end

     if res[1] and next(res[1]) ~= nil then
          for i, v in pairs(res[1]) do
               table.insert(peds, v)
          end
     end

     return peds or false
end))


RegisterCommand("addped", (function(src, args, raw)
     local target = args[1]
     local ped    = args[2]

     if GetResourceState("mate-admin") ~= "started" then
          return mCore.Notify(src, lang.Title,
               lang.error["err_no_adminsys"], "error", 5000)
     end

     local isAdmin = exports["mate-admin"]:isAdmin(src, true)
     if not isAdmin then
          return mCore.Notify(src, lang.Title, lang.error["no_perm"], "error", 5000)
     end

     if not target or not ped then
          return mCore.Notify(src, lang.Title, ("%s /addped <Target> <PedID>"):format(lang.error["correct_usage"]),
               "error", 6000)
     end

     local xTarget = mCore.getXPlayer(target)
     if not xTarget then
          return mCore.Notify(src, lang.Title, (lang.error["no_player_w_id"]):format(target),
               "error", 5000)
     end

     local idf          = GetPlayerIdentifierByType(target, "license"):sub(9)

     local isModelExist = lib.callback.await("mate-pedmenu->IsModelExist", src, ped)

     if not isModelExist then
          return mCore.Notify(src, lang.Title, lang.error["model_not_exist"], "error", 5000)
     end

     MySQL.insert.await("INSERT INTO `mate-peds` (identifier, ped) VALUES (?,?)", { idf, tostring(ped) })

     mCore.Notify(target, lang.Title, (lang.info["ped_recived"]):format(tostring(ped)), "info", 5000)
     mCore.Notify(src, lang.Title,
          (lang.success["ped_givven"]):format(GetPlayerName(target), target, tostring(ped)), "success",
          5000)
end), false)

RegisterCommand("delped", (function(source, args, raw)
     local target = args[1]
     local ped    = args[2]

     if GetResourceState("mate-admin") ~= "started" then
          return mCore.Notify(source, lang.Title,
               lang.error["err_no_adminsys"], "error", 5000)
     end

     local isAdmin = exports["mate-admin"]:isAdmin(source, true)
     if not isAdmin then
          return mCore.Notify(source, lang.Title, lang.error["no_perm"], "error", 5000)
     end


     if not target or not ped then
          return mCore.Notify(source, lang.Title, ("%s /delped <Target> <PedID>"):format(lang.error["correct_usage"]),
               "error", 6000)
     end

     local xTarget = mCore.getXPlayer(target)
     if not xTarget then
          return mCore.Notify(source, lang.Title, (lang.error["no_player_w_id"]):format(target),
               "error", 5000)
     end


     local res2 = MySQL.query.await("DELETE FROM `mate-peds` WHERE identifier = ? AND ped = ?",
          { xTarget.getIdentifier(), tostring(ped) })
     if res2 and res2.affectedRows > 0 then
          mCore.Notify(source, lang.Title,
               (lang.success["ped_removed"]):format(GetPlayerName(target), target, ped), "success",
               5000)
          mCore.Notify(target, lang.Title, (lang.info["ped_has_been_removed"]):format(ped), "info", 5000)

          TriggerClientEvent("mate-pedmenu->PedRemoved", xTarget.source, ped)
     else
          mCore.Notify(source, lang.Title, (lang.error["target_has_no_ped"]):format(GetPlayerName(target), target, ped),
               "error", 5000)
     end
end), false)


lib.callback.register("mate-pedmenu->RequestSkin", (function(source)
     local idf = GetPlayerIdentifierByType(source, "license"):sub(9)


     local skin = MySQL.single.await("SELECT skin FROM `users` WHERE identifier = ?", { idf })

     return json.decode(skin.skin) or false
end))
