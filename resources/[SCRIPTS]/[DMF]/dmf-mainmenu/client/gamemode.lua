local currentGM = nil
local lang = Loc[Config.lan]

RegisterNuiCallback("join", (function(data, cb)
     local joined = lib.callback.await('dmf-mainmenu->JoinMode', false, {
          gamemode = data.gameId,
          mode     = "DMF"
     })

     if not joined then
          print("Error player cannot be connected to gamemode !")
          return cb('error')
     end

     currentGM = data.gameId
     DisplayRadar(true)

     SendNUIMessage({
          action = "setVisibility",
          data = false
     })

     visible = false
     SetNuiFocus(false, false)

     local pos = GetOutPos(data.gameId, data.mode)
     TeleportPlayer(pos.xyz, true)

     if pos.w then
          SetEntityHeading(cache.ped, pos.w)
     end


     NetworkSetEntityInvisibleToNetwork(cache.ped, false)
     SetEntityInvincible(cache.ped, false)

     TriggerEvent("dmf->ShowHUD")

     cb('ok')
end))

RegisterNetEvent('dmf-mainmenu->Update', function()
     local data = lib.callback.await("dmf-mainmenu->GetDat", false)


     SendNUIMessage({
          action = "loadGamemodes",
          data = FormatData(data)
     })
end)

RegisterCommand("leave", (function()
     -- if currentGM == nil or currentGM == false or not currentGM or visible then
     --      return
     -- end

     -- local state = LocalPlayer.state

     -- if state.InCombat and type(state.InCombat) ~= "nil" then
     --      if (GetGameTimer() - state.InCombat <= 15000) then
     --           local dur = 15000
     --           local remaining = (state.InCombat + dur) - GetGameTimer()

     --           return mCore.Notify("[DMF Mainmenu]",
     --                ("Jelenleg Combat állapotban vagy, szabad kilépés : %smp"):format(math.floor(remaining / 1000.0)),
     --                "error", 5000)
     --      end
     -- end

     LeavePlayer()
end))

LeavePlayer = (function()
     exports["mate-spawnmanager"]:Revive()
     SetEntityInvincible(cache.ped, true)
     NetworkSetEntityInvisibleToNetwork(cache.ped, true)
     Wait(500)
     TriggerServerEvent("dmf-mainmenu->Leave")
     currentGM = false
     Wait(200)
     exports[GetCurrentResourceName()]:Open()
end)

exports("GetCurrentGM", (function()
     return currentGM
end))
