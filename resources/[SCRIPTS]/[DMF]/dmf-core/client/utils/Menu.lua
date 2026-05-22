function SetData()
     Players = {}
     for _, Player in ipairs(GetActivePlayers()) do
          table.insert(Players, Player)
     end
     Citizen.InvokeNative(GetHashKey("ADD_TEXT_ENTRY"), 'FE_THDR_GTAO', "~b~DM Frenzy~s~")
end

Citizen.CreateThread(function()
     while true do
          Citizen.Wait(500)
          SetData()
     end
end)


Citizen.CreateThread(function()
     AddTextEntry("PM_PANE_LEAVE", "~p~Kilépés a Szerverről~s~")
     AddTextEntry("PM_PANE_QUIT", "~p~Kilépés a FiveM-ből")
     AddTextEntry('PM_SCR_MAP', '~p~Térkép')
     AddTextEntry('PM_SCR_GAM', '~p~Lecsatlakozás')
     AddTextEntry('PM_SCR_INF', '~p~Információ')
     AddTextEntry('PM_SCR_STA', '~p~Statisztika')
     AddTextEntry('PM_SCR_SET', '~p~Beállítások')
     AddTextEntry('PM_SCR_GAL', '~p~Galéria')
     AddTextEntry('PM_PANE_LEAVE', '~r~Lecsatlakozás')
     AddTextEntry('PM_PANE_QUIT', '~r~Kilépés a játékból')
end)

Citizen.CreateThread((function()
     Wait(5000)
     
     StartAudioScene("DLC_MPHEIST_TRANSITION_TO_APT_FADE_IN_RADIO_SCENE")
     SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_01_STAGE", false)
     SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_02_MAIN_ROOM", false)
     SetStaticEmitterEnabled("LOS_SANTOS_VANILLA_UNICORN_03_BACK_ROOM", false)
     SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Disabled_Zones", false, true)
     SetAmbientZoneListStatePersistent("AZL_DLC_Hei4_Island_Zones", true, true)
     SetScenarioTypeEnabled("WORLD_VEHICLE_STREETRACE", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON_DIRT_BIKE", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_SALTON", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_NEXT_TO_CAR", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_CAR", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_POLICE_BIKE", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_SMALL", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_MILITARY_PLANES_BIG", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_MECHANIC", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_EMPTY", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_BUSINESSMEN", false)
     SetScenarioTypeEnabled("WORLD_VEHICLE_BIKE_OFF_ROAD_RACE", false)
     StartAudioScene("FBI_HEIST_H5_MUTE_AMBIENCE_SCENE")
     StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
     SetAudioFlag("PoliceScannerDisabled", true)
     SetAudioFlag("DisableFlightMusic", true)
     SetPlayerCanUseCover(PlayerId(), false)
     SetRandomEventFlag(false)
     SetDeepOceanScaler(0.0)
end))
