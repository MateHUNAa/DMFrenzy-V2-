ESX    = exports['es_extended']:getSharedObject()
mCore  = exports["mCore"]:getSharedObj()
lang   = Loc[Config.lan]

isDead = false

cam    = nil

RegisterNetEvent('mate-kd:onKill', function(killer, victim)
     if GetPlayerServerId(PlayerId()) == killer.sourceId then return end
     if killer.sourceId == victim.sourceId then return end

     isDead = true

     local killerPed = NetworkGetEntityFromNetworkId(killer.netId)

     Citizen.CreateThread((function()
          cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
          SetCamActive(cam, true)
          RenderScriptCams(true, true, 500, true, true)

          while not DoesCamExist(cam) do
               Wait(20)
          end

          while isDead do
               --
               local killerCoords = GetEntityCoords(killerPed)
               local killerHeading = GetEntityHeading(killerPed)

               SetCamCoord(cam, killerCoords + vec3(1, 1, 1))
               PointCamAtEntity(cam, killerPed, 0, 0, -1, true)
               SetCamRot(cam, 0.0, 0.0, killerHeading, 2)

               --
               Wait(1)
          end
          SendNUIMessage({
               action = "off",
               data = true
          })
     end))

     local killerData = lib.callback.await("dmf->getPlayerData", false, killer.sourceId)

     SendNUIMessage({
          action = "showData",
          data   = {
               discordName  = killerData.discord.name,
               discordId    = killerData.discord.id,
               imageURL     = killerData.discord.img,

               kills        = killerData.kd.kills,
               deaths       = killerData.kd.deaths,
               rank         = killerData.kd.rang,

               killerWeapon = "N/A",

               health       = GetEntityHealth(killerPed) > 100 and GetEntityHealth(killerPed) - 100 or
                   GetEntityHealth(killerPed),
               armour       = GetPedArmour(killerPed)
          } or {
               discordName = "{N/A}MateHUN",
               discordId   = "N/A",
               kills       = 0,
               deaths      = 0,
               rank        = "N/A",
          }
     })
     --
end)

RegisterNetEvent("dmf->OnPlayerSpawn", (function()
     isDead = false
     ClearFocus()
     SetCamActive(cam, false)
     RenderScriptCams(false, false, 0, false, false)
     DestroyCam(cam, false)
     cam = nil
end))


RegisterCommand("killcam:stop", (function()
     isDead = false
     ClearFocus()
     SetCamActive(cam, false)
     RenderScriptCams(false, false, 0, false, false)
     DestroyCam(cam, false)
     cam = nil
end))
