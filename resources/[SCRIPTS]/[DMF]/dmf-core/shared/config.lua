Config = {
     lan = "hu",
     PedRenderDistance = 80.0,
     target = true,
     eventPrefix = "mhScripts"
}
Config.MHAdminSystem = GetResourceState("mate-admin") == "started"
Config.ApprovedLicenses = {
     "license:123",
     "fivem:123",
     "discord:123",
     "live:123",
     "steam:123",
     "xbl:123"
}

Config.GuildID = "1305583250365878433"

Config.Intervals = {
     ["DeleteVehicles"] = (2 * 60 * 1000) -- 2perc
}

Config.StarterItems = {
     ["WEAPON_APPISTOL"]     = 1,
     ["WEAPON_COMBATPISTOL"] = 1,
     --[[ ["money"]               = 5, ]]
     ["vehicle"]             = 1,
     ["suppresor"]           = 2
}

Config.DefaultSettings = {
     ["InfinitAmmo"] = true,
     ["NoRecoil"]    = true,
     ["NoRagdoll"]   = true,
     ["Parachute"]   = false
}

Config.DurabilityBlackList = {
     ["WEAPON_DEADNIGHT"] = true,
     ["WEAPON_WEAPON_GC5GEN"] = true,
     ["WEAPON_VIPGLOCK"] = true
}

Config.FreeVehicles = {
     "akuma",
     "jugular"

}

Loc = {}
