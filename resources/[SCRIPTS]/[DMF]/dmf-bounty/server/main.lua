ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


local IsBountyActive = false

local lastBountyPlayer = nil
local bountyPlayer
local wait = (5 * 60 * 1000)
local initialPlayers = {}

function GetNewBountyPlayer(players, count)
     if count == 0 then return nil end

     local attempts = 0
     local maxAttempts = 50

     while attempts < maxAttempts do
          math.randomseed(GetGameTimer())
          local randomIdx = math.random(1, count)
          local selectedPlayer = players[randomIdx]

          if selectedPlayer then
               local inSafezone = lib.callback.await("dmf->IsPlayerInSafeZone", selectedPlayer.sourceId)

               if not inSafezone and (not lastBountyPlayer or selectedPlayer.sourceId ~= lastBountyPlayer.sourceId) then
                    return selectedPlayer
               end
          end

          attempts = attempts + 1
          Wait(0)
     end

     return nil
end

Citizen.CreateThread((function()
     Wait(2000)
     while true do
          local players, count = exports["mate-dimManager"]:GetPlayersInBucket("freeroam", "DMF")
          initialPlayers = players

          if not IsBountyActive then
               if count < Config.MinPlayer then
                    wait = (1 * 60 * 1000)
               else
                    wait             = (5 * 60 * 1000)

                    bountyPlayer     = GetNewBountyPlayer(players, count)

                    lastBountyPlayer = bountyPlayer
                    IsBountyActive   = true

                    TriggerClientEvent("dmf-bounty:DisplayMessage", -1, "[DMF Bounty]",
                         ("Bounty Aktív ~r~ ~h~%s~h~ ~w~ Térképen Pingelve!"):format(GetPlayerName(
                              bountyPlayer.sourceId)))
                    StartBounty()
               end
          end
          Wait(wait)
     end
end))

function StartBounty()
     if not bountyPlayer then
          return print("Failed to start bounty no bountyPlayer")
     end
     TriggerClientEvent("dmf-bounty:StartBounty", -1, bountyPlayer.sourceId)
end

RegisterNetEvent('dmf-bounty:Canceled', function()
     TriggerClientEvent('dmf-bounty:RemoveBlip', -1)
     bountyPlayer     = nil
     lastBountyPlayer = nil
end)


RegisterNetEvent('esx:playerDropped', function(playerId, reason)
     if not bountyPlayer then return end
     if bountyPlayer.sourceId == playerId then
          TriggerEvent("dmf-bounty:Canceled")
          wait = (1 * 60 * 1000)
          mCore.Notify(-1, "[DMF Bounty]", "Kilépett a játékos akin bounty volt!", "error", 10000)
     end
end)


RegisterNetEvent('mate-kd:onKill', function(killer, victim, headshot)
     if not bountyPlayer then return end
     if victim.sourceId ~= bountyPlayer.sourceId then return end
     IsBountyActive = false
     bountyPlayer   = nil

     local reward   = Config.Reward

     local found    = false
     for i, v in pairs(initialPlayers) do
          if v.sourceId == killer.sourceId then
               found = true
               break
          end
     end

     if found then
          reward += Config.InitialPlayerReward
     end

     exports["ox_inventory"]:AddItem(killer.sourceId, "money", reward)
     mCore.sendMessage(
          ("%s(%s) Recied %s `money` for killing the bounty target: %s(%s) | IsKillerInitialPlayer?: %s"):format(
               GetPlayerName(killer.sourceId), killer.sourceId,
               reward,
               GetPlayerName(victim.sourceId), victim.sourceId,
               found and "✅" or "❌"
          ), mCore.RequestWebhook("money"), ("mCore, %s"):format(GetCurrentResourceName() or "N/A"))

     mCore.Notify(-1, "[DMF Bounty]", ("Bounty sikeresen megölve általa: %s"):format(GetPlayerName(killer.sourceId)),
          "success", 5000)
     TriggerClientEvent('dmf-bounty:RemoveBlip', -1)
end)
