ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()
lang  = Loc[Config.lan]



RegisterCommand("matchmake", (function(src, args, raw)
     TriggerServerEvent('mate-wagerv2:ToggleMatchmake', {})
end))
