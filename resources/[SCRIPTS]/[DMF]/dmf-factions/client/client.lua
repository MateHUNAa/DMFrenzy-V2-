mCore = exports["mCore"]:getSharedObj()
BlipState, TKState = false, false

-- ## MENU FUNCTIONS ## --
function OpenFactionSettings()
    lib.registerContext({
        id = 'faction_settings',
        title = 'Frakció Beállítások',
        options = {
            {
                title = 'Frakció társ blippek',
                description = BlipState and 'Bekapcsolva' or 'Kikapcsolva',
                icon = 'location-dot',
                onSelect = function()
                    BlipState = not BlipState
                    TriggerServerEvent('dmf-factions:ToggleFactionBlips', BlipState)

                    OpenFactionSettings()
                end
            },
            {
                title = 'Frakció TK',
                description = TKState and 'Bekapcsolva' or 'Kikapcsolva',
                icon = 'people-group',
                onSelect = function()
                    TriggerEvent("dmf-factions->ToggleAntiTK", TKState)
                    OpenFactionSettings()
                end
            },
        }
    })
    lib.showContext('faction_settings')
end

-- ## EVENT HANDLERS ## --

RegisterCommand('factionmenu', OpenFactionSettings)
RegisterKeyMapping('factionmenu', 'Frakció menü megnyitása', 'keyboard', 'F6')

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Init
CreateThread(function()
    while not ESX.PlayerData.job do
        Wait(100)
    end
end)


exports("GetGarage", (function(job)
    return Config.Factions[job].FactionsAccess.Vehicles
end))


-- 147ln
lib.callback.register("dmf-factions->HandleJobRequst", (function(data)
    print("data", json.encode(data, { indent = true }))

    local dialog = lib.alertDialog({
        header = "[DMF Factions]",
        content = ("Job invitation from %s(%s) to %s"):format(data.name or "N/A", data.leaderId or "N/A",
            data.job or "N/A")
    })

    if dialog == 'confirm' then
        return true
    end


    return false
end))
