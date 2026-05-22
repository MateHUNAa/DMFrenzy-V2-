ESX = exports["es_extended"]:getSharedObject()

CreateThread(function()
    for k, v in pairs(Config.Factions) do
        if not ESX.DoesJobExist(k, 0) then
            local result = MySQL.scalar.await('SELECT COUNT(*) FROM `jobs` WHERE name = ?', { k })

            if result == 0 then
                MySQL.insert.await('INSERT INTO jobs (name, label, whitelisted) VALUES (?, ?, ?)', {
                    k, v.FactionsAccess.Label, 1
                })

                for grade, gradeData in pairs(v.FactionsAccess.Faction_Ranks) do
                    MySQL.insert.await(
                        'INSERT INTO job_grades (job_name, grade, name, label, salary, skin_male, skin_female) VALUES (?, ?, ?, ?, ?, ?, ?)',
                        {
                            k, grade, gradeData.Value, gradeData.Label, gradeData.Salary or 0, '{}', '{}'
                        })
                end



                MySQL.insert.await("INSERT INTO `mate_factionkd` (job, kills, deaths, headshots) VALUES (?,0,0,0)", { k })



                print(('[SUCCESS] %s frakció létrehozva'):format(k))
                ESX.RefreshJobs()
            end
        end
    end
end)

ESX.RegisterServerCallback('esx_society:getPlayerJob', function(source, cb, targetId)
    local xPlayer = ESX.GetPlayerFromId(targetId)
    cb(xPlayer and xPlayer.getJob() or nil)
end)

ESX.RegisterServerCallback('esx_society:setJob', function(source, cb, targetId, jobName, grade, action)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(targetId)

    if not xTarget then
        print(('[ERROR] Target player not found: %s'):format(targetId))
        cb(false)
        return
    end

    if not xPlayer or not xPlayer.job or not xPlayer.job.grade_name or
        not xPlayer.job.grade_name:match('boss') then
        print(('[ERROR] No permission: %s'):format(xPlayer and xPlayer.identifier or 'unknown'))
        cb(false)
        return
    end

    if action == "hire" then
        if xTarget.job.name ~= "unemployed" then
            mCore.Notify(xPlayer.source, "[DMF Factions]", "This player already in a faction !", "error", 5000)
            cb(false)
            return
        end

        local accepted = lib.callback.await("dmf-factions->HandleJobRequst", targetId, {
            name     = GetPlayerName(xPlayer.source),
            leaderId = tostring(xPlayer.source),
            job      = jobName
        })

        if not accepted then
            cb(false)
            return
        end

        xTarget.setJob(jobName, grade)

        mCore.Notify(xTarget.source, "[DMF Factions]", ("Felvettek a frakcióba: %s"):format(jobName), "success", 10000)
        mCore.Notify(source, "[DMF Factions]", ("Sikeresen felvetted %s-t!"):format(xTarget.getName()), "success", 10000)

        print(('[ACTION] %s felvette %s-t a %s frakcióba'):format(
            xPlayer.getName(), xTarget.getName(), jobName))

        cb(true)
        return
    elseif action == "fire" then
        if xTarget.job.name ~= xPlayer.job.name then
            mCore.Notify(xPlayer.source, "[DMF Factions]", "Ez a játékos nem a frakciód tagja!", "error", 5000)
            cb(false)
            return
        end

        xTarget.setJob('unemployed', 0)
        mCore.Notify(xTarget.source, "[DMF Factions]", "Kirúgtak a frakcióból!", "warning", 10000)
        mCore.Notify(xPlayer.source, "[DMF Factions]", ("Sikeresen kirúgtad %s-t!"):format(GetPlayerName(xTarget.source)),
            "success", 5000)
        cb(true)
        return
    elseif action == "promote" then
        local maxRank = #Config.Factions[jobName].FactionsAccess.Faction_Ranks - 1

        if xPlayer.getJob().grade <= xTarget.getJob().grade then
            return mCore.Notify(xPlayer.source, "[DMF Factions]",
                "Nincs jogosultságod ennek a frakciótagnak a kezeléséhez!", "error", 5000)
        end

        if grade <= maxRank then
            xTarget.setJob(jobName, grade)
            Wait(200)
            mCore.Notify(xTarget.source, "[DMF Factions]",
                ("Előléptettek: %s (Rang: %s)"):format(jobName, xTarget.getJob()["grade_name"]), "info", 10000)
            mCore.Notify(source, "[DMF Factions]", ("Sikeresen előléptetted %s-t!"):format(xTarget.getName()), "success",
                10000)

            cb(true)
        else
            mCore.Notify(source, "[DMF Factions]", "Nem létezik magasabb rang!", "error", 5000)
            cb(false)
        end

        -- Lefokozás kezelése
    elseif action == "demote" then
        if xPlayer.getJob().grade <= xTarget.getJob().grade then
            return mCore.Notify(xPlayer.source, "[DMF Factions]",
                "Nincs jogosultságod ennek a frakciótagnak a kezeléséhez!", "error", 5000)
        end

        if grade >= 0 then
            xTarget.setJob(jobName, grade)
            mCore.Notify(xTarget.source, "[DMF Factions]",
                ("📉 Lefokoztak: %s (Rang: %s)"):format(jobName, xTarget.getJob()["grade_name"]), "warning", 5000)
            mCore.Notify(source, "[DMF Factions]", ("Sikeresen lefokoztad %s-t!"):format(xTarget.getName()), "info",
                5000)

            cb(true)
        else
            mCore.Notify(source, "[DMF Factions]", "Nem lehet tovább lefokozni!", "error", 5000)
            cb(false)
        end
    else
        mCore.Notify(xPlayer.source, "[DMF Factions]", "Something went wrong! Please try again !", "error", 5000)
        print(('[ERROR] Ismeretlen action: %s'):format(action))
        cb(false)
    end
end)

-- Online játékosok listája
ESX.RegisterServerCallback('esx_society:getOnlinePlayers', function(source, cb)
    local players = {}
    for _, xPlayer in pairs(ESX.GetExtendedPlayers()) do
        table.insert(players, {
            source = xPlayer.source,
            identifier = xPlayer.identifier,
            name = xPlayer.getName(),
            job = xPlayer.getJob()
        })
    end
    cb(players)
end)

lib.callback.register("esx_society:getEmployees", (function(source, jobName)
    local employees = {}
    for _, xPlayer in pairs(ESX.GetExtendedPlayers("job", jobName)) do
        table.insert(employees, {
            name       = GetPlayerName(xPlayer.source),
            identifier = xPlayer.getIdentifier(),
            job        = xPlayer.getJob(),
            source     = xPlayer.source
        })
    end

    return employees
end))

-- Frakciók frissítése parancs
RegisterCommand("refreshjobs", function(source)
    ESX.RefreshJobs()
    print("^2[SUCCESS]^0 Frakciók frissítve!")
end, true)


exports("GetFactions", (function(faction)
    if faction then
        return Config.Factions[faction]
    end

    local val = Config.Factions

    return val
end))


exports("GetLeaderRoles", (function()
    return { ["boss"] = Config.LeaderRole, ["underboss"] = Config.SubLeaderRole } or false
end))
