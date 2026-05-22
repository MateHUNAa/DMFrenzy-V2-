if ESX == nil then
    TriggerEvent("esx:getSharedObject", function(obj) ESX = obj end)
end

local updateDiscordId = "UPDATE `mate_kd` SET discordid = ? WHERE identifier = ?"

Functions = {
    insertDiscordId = function(xPlayer)
        if not xPlayer then return end
        local discordId = exports["mCore"]:split(GetPlayerIdentifierByType(xPlayer.source, "discord"), ":")[2]
        local license   = exports["mCore"]:split(GetPlayerIdentifierByType(xPlayer.source, "license"), ":")[2]
        while not discordId do Wait(50) end

        MySQL.update(updateDiscordId, {
            discordId, license
        }, function(affectedRows)
        end)
    end,

    createMateKDTable = function()
        local p = promise.new()

        local tableExists = MySQL.scalar.await("SHOW TABLES LIKE 'mate_kd'")
        if tableExists then
            return p:resolve(false) -- Table already exists
        end

        local query = [[
            CREATE TABLE IF NOT EXISTS `mate_kd` (
                `identifier` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
                `kills` int NOT NULL DEFAULT (0),
                `deaths` int NOT NULL DEFAULT (0),
                `headshot` int NOT NULL DEFAULT (0),
                `discordid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                `npc_killed` int DEFAULT NULL,
                `player_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                `rang` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
                KEY `Index 1` (`discordid`),
                KEY `Rang key` (`rang`),
                CONSTRAINT `FK_mate_kd_rime_rang` FOREIGN KEY (`rang`) REFERENCES `rime_rang` (`name`),
                CONSTRAINT `FK_mate_kd_users` FOREIGN KEY (`discordid`) REFERENCES `users` (`discordid`)
              ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
    ]]

        MySQL.execute(query, {}, function(success)
            if success then
                p:resolve(true)
            else
                p:reject("Failed to create table mate_kd")
            end
        end)

        return p
    end,

    insertPlayerName = function(xPlayer)
        if not xPlayer then return end
        local playerName = GetPlayerName(xPlayer.source)
        local license    = exports["mCore"]:split(GetPlayerIdentifierByType(xPlayer.source, "license"), ":")[2]
        while not license do Wait(50) end

        MySQL.update("UPDATE `mate_kd` SET player_name = ? WHERE identifier = ?", {
            playerName,
            license
        }, function(affectedRows)
        end)
    end,
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
   end,
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
    end),

}
