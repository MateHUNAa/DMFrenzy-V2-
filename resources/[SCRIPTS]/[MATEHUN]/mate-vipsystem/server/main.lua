---@diagnostic disable: param-type-mismatch
mCore = exports["mCore"]:getSharedObj()

local VIPPlayers = {}

Citizen.CreateThread((function()
     local table = {
          "`discordId` varchar(255) NOT NULL DEFAULT 'NAN' PRIMARY KEY",
          "`level` tinyint(12) NOT NULL DEFAULT 0",
          "`experiation_date` datetime NOT NULL",
          "`create_date` datetime NOT NULL DEFAULT current_timestamp()",
          "`roleId` varchar(50) NOT NULL"
     }

     mCore.createSQLTable("mate_vipsystem", table)
end))


--- @function IsPlayerVIP
--- @param identifier "DiscordID"|"Identifier"|"PlayerID"
--- @return boolean
IsPlayerVIP = (function(identifier)
     local found, type, id = ParseIdentifier(identifier)
     if not found then return false end

     local CheckPlayerHasVIP = (function(discord, idf)
          local query = ("SELECT * FROM `mate_vipsystem` WHERE %s = ?"):format(discord and "discordId" or "identifier")

          local res = MySQL.single.await(query, {
               idf
          })


          if not res then return false else return true end
     end)

     local hasVIP = false
     if type == "discord" then
          hasVIP = CheckPlayerHasVIP(true, id)
     elseif type == "license" then
          hasVip = CheckPlayerHasVIP(false, id)
     elseif type == "playerid" then
          local did = GetPlayerIdentifierByType(id, "discord"):sub(9)
          hasVIP = CheckPlayerHasVIP(true, did)
     end

     return hasVIP
end)
exports("IsPlayerVIP", IsPlayerVIP)



---@function GetVIPLevel
--- @param identifier "DiscordID"|"Identifier"|"PlayerID"
--- @return boolean,number
GetPlayerVIPLevel = (function(identifier)
     local found, type, id = ParseIdentifier(identifier)
     if not found then return false, 0 end

     local Query = (function(discord, idf)
          local query = ("SELECT * FROM `mate_vipsystem` WHERE %s = ?"):format(discord and "discordId" or "identifier")

          local res = MySQL.single.await(query, {
               idf
          })

          if not res then
               return false, 0
          end


          return true, res["level"]
     end)

     local a, b
     if type == "discord" then
          a, b = Query(true, id)
     elseif type == "license" then
          a, b = Query(false, id)
     elseif type == "playerid" then
          local did = GetPlayerIdentifierByType(id, "discord"):sub(9)
          a, b = Query(true, did)
     end

     return a, b
end)
exports("GetVIPLevel", GetPlayerVIPLevel)
exports("GetPlayerVIPLevel", GetPlayerVIPLevel)



---@function HasVIPLevel
---@param identifier "DiscordID"|"Identifier"|"PlayerID"
---@param requiredLevel number
---@return boolean
HasVIPLevel = (function(identifier, requiredLevel)
     local found, type, id = ParseIdentifier(identifier)
     if not found then return false end

     local Query = (function(discord, idf)
          local query = ("SELECT * FROM `mate_vipsystem` WHERE %s = ?"):format(discord and "discordId" or "identifier")

          local res = MySQL.single.await(query, {
               idf
          })

          if not res then
               return false
          end

          if requiredLevel >= res["level"] then
               return true
          else
               return false
          end

          return false
     end)

     local has

     if type == "discord" then
          has = Query(true, id)
     elseif type == "license" then
          has = Query(false, id)
     elseif type == "playerid" then
          local did = GetPlayerIdentifierByType(id, "discord"):sub(9)
          has = Query(true, did)
     end

     return has
end)
exports("HasVIPLevel", HasVIPLevel)


---@function SetPlayerVIPLevel
---@param identifier "DiscordID"|"Identifier"|"PlayerID"
---@param newLevel number
---@return boolean,number,boolean
SetPlayerVIPLevel = (function(identifier, newLevel)
     if true then
          ---@diagnostic disable-next-line: missing-return-value, return-type-mismatch
          return "WORK IN PROGRESS"
     end
     local found, type, id = ParseIdentifier(identifier)
     local success = false
     local updated = false
     if not found then return false, 0, false end

     ---@return boolean
     local Query = (function(discord, idf)
          local insertQuery = ("INSERT INTO `mate_vipsystem` (identifier, discordId, level, experiation_date) VALUES(?,?,?,?,?)")
          local updateQuery = ("UPDATE `mate_vipsystem` level = ? WHERE %s = ?"):format(discord and "discordId" or
               "identifier")

          local res


          local playerDiscord
          local playerIdentfier
          local playerID = GetPlayerIDByIdentifier(idf)

          if discord then
               playerDiscord = idf
               playerIdentfier = GetPlayerIdentifierByType(playerID, "license"):sub(9)
          else
               playerDiscord = GetPlayerIdentifierByType(playerID, "discord"):sub(9)
               playerIdentfier = idf
          end


          if updated then
               res = MySQL.single.update(updateQuery, {
                    newLevel, idf
               })
          else
               res = MySQL.single.await(insertQuery, {
                    playerIdentfier, playerDiscord, newLevel, --TODO: experiation_date
               })
          end

          if not res then return false else return true end
     end)


     local isVIP, level = GetPlayerVIPLevel(identifier)
     if isVIP then
          if level > newLevel then
               success = true
               return success, level, updated
          else
               updated = true
          end
     end



     if type == "discord" then
          success = Query(true, id)
     elseif type == "license" then
          success = Query(false, id)
     elseif type == "playerid" then
          local did = GetPlayerIdentifierByType(id, "discord"):sub(9)
          success = Query(true, did)
     end


     return success, level, updated
end)
exports("setvip", SetPlayerVIPLevel)

GetPlayerIDByIdentifier = (function(identifier)
     local found, type, id = ParseIdentifier(identifier)
     if not found then return false end

     if type == "playerid" then return true, id end

     if type == "discord" then
          for _, pid in pairs(GetPlayers()) do
               local did = GetPlayerIdentifierByType(pid, "discord")
               if string.match(tostring(did), tostring(id)) then
                    return true, pid
               end
          end
     elseif type == "license" then
          for _, pid in pairs(GetPlayers()) do
               local did = GetPlayerIdentifierByType(pid, "license")
               if string.match(tostring(did), tostring(id)) then
                    return true, pid
               end
          end
     end

     return false, 0
end)

ParseIdentifier = function(identifier)
     local function hasIDTag(idf)
          if string.match(idf, '^discord:') then
               return true, "discord", idf:sub(9)
          elseif string.match(idf, "^license:") then
               return true, "license", idf:sub(9)
          end
          return false, nil, nil
     end

     if type(identifier) == "number" then
          for _, id in pairs(GetPlayers()) do
               local did = GetPlayerIdentifierByType(id, "discord"):sub(9)

               if string.match(tostring(did), tostring(identifier)) then
                    return true, "discord", did
               end
          end


          local len = #tostring(identifier)
          if len < 4 then -- Probably a PlayerID
               for _, id in pairs(GetPlayers()) do
                    if string.match(tostring(id), tostring(identifier)) then
                         return true, "playerid", identifier
                    end
               end
          end


          return false, nil, nil
     elseif type(identifier) == "string" then
          local hasTag, type, formated = hasIDTag(identifier)


          for _, id in pairs(GetPlayers()) do
               local did = GetPlayerIdentifierByType(id, "discord"):sub(9)

               if string.match(tostring(did), tostring(identifier)) then
                    return true, "discord", did
               end
          end

          if hasTag then
               return true, type, formated -- found, type, formatedLic
          else
               return false, nil, nil
          end
     end
end

function IsPlayerAdmin(pid)
     if Config.MHAdminSystem then
          return exports["mate-admin"]:isAdmin(pid)
     else
          local identifiers = GetPlayerIdentifiers(pid)

          for _, v in pairs(Config.ApprovedLicenses) do
               for _, lic in pairs(identifiers) do
                    if v == lic then
                         return true
                    end
               end
          end

          return false
     end
end

--
--
--

---@class vipData
---@field discordId string
---@field level number
---@field expiration_date osdate
---@field create_date osdate
---@field roleId string

Citizen.CreateThread((function()
     while true do
          --

          local data = MySQL.query.await("SELECT * FROM  `mate_vipsystem`") ---@

          if not VIPPlayers or next(VIPPlayers) == nil then
               VIPPlayers = data
               goto continue
          end

          for i, oldVip in pairs(VIPPlayers) do
               for i, pid in pairs(GetPlayers()) do
                    local isVip = exports[GetCurrentResourceName()]:IsPlayerVIP(pid)
                    local idf = GetPlayerIdentifierByType(pid, "discord"):sub(9)
                    if oldVip == idf then
                         if not isVip then
                              TriggerClientEvent("mate-vipsystem->VipExpired", pid)
                              TriggerEvent("mate-vipsystem->VipExpired", pid)
                         end
                         break
                    end
               end
          end

          --
          ::continue::
          Wait(5000)
     end
end))
