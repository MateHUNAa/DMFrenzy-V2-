RegisterNetEvent('esx:playerLoaded', function(player, xPlayer, isNew)
     Wait(3000)
     local discordData = mCore.GetDiscordAwait(player)

     if not discordData then
          discordData = {}
          discordData.id = GetPlayerIdentifierByType(player, "discord"):sub(9)
     end

     exports["discord_rest"]:getGuildMember(Config.GuildID, discordData.id):next((function(member)
          local jobLevel = JobLevel(member.roles)
          local job      = GetJob(member.roles)

          if jobLevel > 0 and job == "unemployed" then
               mCore.error(("[DiscordSetjob]: Error in the matrix ! %s(%s) has leader role but cannot find a Faction Role on the user !")
                    :format(GetPlayerName(player), player))
               mCore.Notify("[DMF Factions]", "Your faction changed to `unemployed` !", "error", 10000)
               jobLevel = 0
          end

          xPlayer.setJob(job, jobLevel)
     end))
end)


Citizen.CreateThread((function()
     while true do
          Wait(2 * 60 * 1000) -- 2min

          for i, xPlayer in pairs(ESX.GetExtendedPlayers()) do
               local discordData = mCore.GetDiscordAwait(xPlayer.source)
               local currentJob = xPlayer.getJob()

               if not discordData then
                    discordData = {}
                    discordData.id = GetPlayerIdentifierByType(xPlayer.source, "discord"):sub(9)
               end

               exports["discord_rest"]:getGuildMember(Config.GuildID, discordData.id):next((function(member)
                    local job    = GetJob(member.roles)
                    local jobLvL = JobLevel(member.roles)

                    if jobLvL > 0 and job == "unemployed" then
                         jobLvL = 0
                    end

                    if job ~= currentJob.name or jobLvL ~= currentJob.grade then
                         xPlayer.setJob(job, jobLvL)
                         print("Player job has been changed !")
                    end
               end))
          end
     end
end))

JobLevel = (function(userRoles)
     local leaderRoles = exports["dmf-factions"]:GetLeaderRoles()

     if not leaderRoles then
          mCore.error("[discordSetJob]: Failed to get leaderRoles !")
          return 0
     end

     local val = 0

     for i, userRole in pairs(userRoles) do
          if userRole == leaderRoles["boss"] then
               val = 2
               break
          end

          if userRole == leaderRoles["underboss"] then
               val = 1
               break
          end
     end

     return val
end)


GetJob = (function(userRoles)
     local Factions = exports["dmf-factions"]:GetFactions()

     local job = "unemployed"
     for i, userRole in pairs(userRoles) do
          for factionKey, factionData in pairs(Factions) do
               if userRole == factionData.discordRole then
                    job = factionKey
                    break
               end
          end
     end

     return job
end)
