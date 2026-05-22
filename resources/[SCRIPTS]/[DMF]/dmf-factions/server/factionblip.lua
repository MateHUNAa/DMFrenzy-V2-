mCore = exports["mCore"]:getSharedObj()

RegisterNetEvent('dmf-factions:ToggleFactionBlips', function(newState)
     local src = source

     if not newState then
          return TriggerClientEvent('dmf-factions:removeTeamBlips', src)
     end

     local xPlayer = mCore.getXPlayer(src)
     local playerJob = xPlayer.getJob().name

     if playerJob == "unemployed" then return end

     local Players = {}

     for _, player in pairs(ESX.GetExtendedPlayers("job", playerJob)) do
          table.insert(Players, {
               id   = player.source,
               name = GetPlayerName(player.source)
          })
     end

     TriggerClientEvent('dmf-factions:CreateTeammateBlips', src, Players)
end)
