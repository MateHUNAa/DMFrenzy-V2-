Config                     = {
     lan = "en",
     PedRenderDistance = 80.0,
     target = true,
     eventPrefix = "mhScripts",
     debug = true
}

Config.Webhooks            = {
     ["removedItems"] = ""
}

Config.MHAdminSystem       = GetResourceState("mate-admin") == "started"

Config.ApprovedLicenses    = {
     "license:123",
     "fivem:123",
     "discord:123",
     "live:123",
     "steam:123",
     "xbl:123"
}

Config.SpawnPoints         = {
     vector4(228.6544, -799.6544, 30.5912, 335.2873),  -- Fo public

}

Config.RespawnTime         = {
     ["Default"] = (10) -- secounds
}

Config.SaveDeathStatus     = false -- true: Load the death status
Config.UseTimeCycleOnDeath = true  -- Effects on Die
Config.SpawnProtection     = 3000  -- 3 Sec

Config.RemoveItemsOnDead   = true
Config.BlackListFilter     = true -- Meta: mhNoRemove

Loc                        = {}
