Config = {
     lan               = "hu",
     PedRenderDistance = 80.0,
     target            = true,
     eventPrefix       = "mhScripts"
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

Config.PedPosition = vector4(1561.5902, 412.2888, -49.6644, 355.0229)
Config.CamPosition = vector4(1561.5061, 417.7616, -49.6649+1, 182.2730)


Config.VIPPeds = {
     {
          ped    = "Caveira",
          minVip = 1
     },
     {
          ped    = "Caveira",
          minVip = 2
     }
}

Config.DefaultPeds = {
     'mp_m_freemode_01',
     "mp_f_freemode_01"
}

Loc = {}
