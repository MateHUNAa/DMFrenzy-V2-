ESX = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()

AddEventHandler('mate-kd:onKill', function(killer, victim, headshot)
     if killer.type ~= "player" or victim.type ~= "player" then return end
     if killer.sourceId == victim.sourceId then return end

     if not killer.sourceId or not victim.sourceId then return end
     if killer.sourceId == 0 or victim.sourceId == 0 then return end

     local xPlayer = ESX.GetPlayerFromId(killer.sourceId)
     local xTarget = ESX.GetPlayerFromId(victim.sourceId)

     if not xPlayer or not xTarget then return end

     local killerJob = xPlayer.getJob()
     local victimJob = xTarget.getJob()

     if victimJob.name ~= "unemployed" then
          exports.oxmysql:execute(
               'UPDATE `mate_factionkd` SET `kills` = `kills` + 1, `headshots` = IF(?, `headshots` + 1, `headshots`) WHERE `job` = ?',
               { headshot, killerJob.name },
               function(response)
                    if response then
                         if response.affectedRows > 0 then
                         end
                    end
               end
          )
     end

     if victimJob.name ~= "unemployed" then
          exports.oxmysql:execute(
               'UPDATE `mate_factionkd` SET `deaths` = `deaths` + 1 WHERE `job` = ?',
               { victimJob.name },
               function(response)
                    if response then
                         if response.affectedRows > 0 then
                         end
                    end
               end
          )
     end
end)
