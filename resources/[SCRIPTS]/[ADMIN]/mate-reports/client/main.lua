local debug = GetConvar("matehun:global_debug", "0") ~= "0"



if not debug then
    print = function()

    end
end

RegisterCommand("report", (function(src, args)
    SendNUIMessage({
        type = "m-report:sendReport",
        state = true
    })

    SetNuiFocus(true, true)
end), false)

RegisterCommand("reports", (function()
    ESX.TriggerServerCallback('mate-report:isAdmin', function(isAdmin)
        print(isAdmin)
        if not isAdmin then return end
        SendNUIMessage({
            type = "m-report:setVisible",
            state = true
        })
        SetNuiFocus(true, true)
    end)
end), false)

RegisterCommand("_cachedReports", (function()
    ESX.TriggerServerCallback('mate-report:isAdmin', function(isAdmin)
        if not isAdmin then return end

        local playerId = GetPlayerServerId(PlayerId())
        TriggerServerEvent("m-reports:s:getCachedReports", playerId)
    end)
end), false)



RegisterNUICallback(":sendReportStats", function(body, cb)
    SetNuiFocus(false, false)
    local subject     = body["subject"]
    local description = body["problemDescription"]
    local category    = body["category"]

    local pid         = GetPlayerServerId(PlayerId())
    TriggerServerEvent("mate-reports:s:sendReport", pid, subject, description, category)

    cb(true)
end)

RegisterNUICallback(":exitMenu", function(body, cb)
    SendNUIMessage({
        type = "m-report:setVisible",
        state = false
    })
    SetNuiFocus(false, false)
    cb(true)
end)


RegisterNUICallback("m-reports:sendClamied", function(body, cb)
    print(json.encode(body, { indent = true }))
    TriggerServerEvent("mate-reports:s:recivedClaimeds", body["index"])
    cb(true)
end)

RegisterNetEvent("mate-reports:c:updateClaimed", (function(data)
    SendNUIMessage({
        type = "m-report:updateClaimed",
        index = data
    })
end))



RegisterNetEvent("mate-report:reciveData", function(data)
    SendNUIMessage({
        type              = "m-report:addData",
        PlayerName        = data.PlayerName,
        msg               = data.PlayerMessage,
        claimed           = false,
        category          = data.category,
        initiatorServerId = data.initiatorServerId,
        identifier        = data.identifier
    })
end)


RegisterNUICallback(":deleteReport", function(body, cb)
    TriggerServerEvent("m-reports:s:deleteReport", body)
    cb(true)
end)


RegisterNetEvent("m-reports:c:deleteReport", (function(data)
    SendNUIMessage({
        type       = "m-deleteReport",
        identifier = data['identifier'],
        id         = data["id"]
    })
end))


RegisterNUICallback(":goto", function(body, cb)
    TriggerServerEvent('mate-admin:command:goto', body.id)

    cb(true)
end)

RegisterNUICallback(":bring", function(body, cb)
    TriggerServerEvent('mate-admin:command:bring', body.id)

    cb(true)
end)


RegisterNUICallback(":DOMLoaded", function(body, resultCallback)
    local playerId = GetPlayerServerId(PlayerId())
    TriggerServerEvent('m-reports:s:getCachedReports', playerId)
    resultCallback(true)
end)
