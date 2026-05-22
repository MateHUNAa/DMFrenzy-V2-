Config                  = {
     lan = "en",
     PedRenderDistance = 80.0,
     target = true,
     eventPrefix = "mhScripts"
}

Config.MHAdminSystem    = GetResourceState("mate-admin") == "started"

Config.ApprovedLicenses = {
     "license:123",
     "fivem:123",
     "discord:123",
     "live:123",
     "steam:123",
     "xbl:123"
}

Config.MarkerTemplates  = {
     ["Shop"] = {
          streamDistance = 15,
          typ            = 1,
          scale          = vector3(1.95, 1.95, 0.75),
          upDown         = false,
          rotate         = false,
          color          = { 128,128,128, 150 },
          help           = "Shop Robbery",
          txdKey         = "markers-txd",
          txdVal         = "robbery"
     },
     ["Bank"] = {
          streamDistance = 15,
          typ            = 1,
          scale          = vector3(1.95, 1.95, 0.75),
          upDown         = false,
          rotate         = false,
          color          = { 50, 50, 200, 150 },
          help           = "Bank Robbery",
          txdKey         = "markers-txd",
          txdVal         = "robbery"
     },
     ["House"] = {
          streamDistance = 15,
          typ            = 1,
          scale          = vector3(1.95, 1.95, 0.75),
          upDown         = false,
          rotate         = false,
          color          = { 200, 50, 50, 150 },
          help           = "House Robbery",
          txdKey         = "markers-txd",
          txdVal         = "robbery"
     },
     ["Police"] = {
          streamDistance = 15,
          typ            = 1,
          scale          = vector3(1.95, 1.95, 0.75),
          upDown         = false,
          rotate         = false,
          color          = { 255,215,0, 150 },
          help           = "House Robbery",
          txdKey         = "markers-txd",
          txdVal         = "robbery"
     },
}

Config.useMultiplier    = true
Config.Multiplier       = 1.5
Config.MaxRobs          = 2

Config.Shops            = {
     ["Shop"] = {
          minPlayer   = 1,
          Cooldown    = (2 * 60 * 1000), --(3 * 60 * 1000), -- 3 min Time to rob
          RestoreTime = (1 * 60 * 1000),         -- Time for can rob again?
          Distance    = 18,
          category    = 13,
          Sprite      = 59,
          Col         = 39,
          size        = 0.8,
          Reward      = { min = 1, max = 2 },
          coords      = {
               vec3(27.6, -1340.01, 28.52),
               vec3(1736.32, 6419.47, 34.03),
               vec3(1961.24, 3749.46, 31.34),
               vec3(-709.17, -904.21, 18.21),
               vec3(1990.57, 3044.95, 46.21),
               vec3(-2959.33, 388.21, 13.00),
               vec3(1126.80, -980.40, 44.41),
               vec3(-1219.85, -916.27, 10.32),
               vec3(-43.40, -1749.20, 28.42),
               vec3(1160.67, -314.40, 68.20),
               vec3(-622.04, -230.87, 37.08),
               vec3(-3248.776, 1004.768, 10.832),
               vec3(545.936, 2663.6, 40.16),
               vec3(2549.832, 387.28, 106.624),
               vec3(2674.104, 3287.488, 53.24)
               
          }
     },

     ["House"] = {
          minPlayer   = 6,
          Cooldown    = (1 * 60 * 1000),
          RestoreTime = (3 * 60 * 1000),
          Distance    = 80,
          category    = 14,
          Sprite      = 40,
          Col         = 1,
          size        = 1.0,
          Reward      = { min = 1, max = 8 },
          coords      = {
               vec4(1392.184, 3607.192, 37.944, 267.488),
               vec4(-1153.816, -1522.024, 9.64, 306.2672),
               vec4(-10.76, -1428.808, 30.104, 178.0496),
               vec4(1273.592, -1709.104, 53.768, 14.9072),
               vec4(-801.8566, 178.3325, 75.7408, 122.4709),
          }
     },
     ["Bank"] = {
          minPlayer   = 5,
          Cooldown    = (2 * 60 * 1000),
          RestoreTime = (1 * 60 * 1000),
          Distance    = 80,
          category    = 15,
          Sprite      = 108,
          Col         = 24,
          size        = 1.0,
          Reward      = { min = 1, max = 3 },
          coords      = {
               vec4(-2956.608, 481.736, 14.696, 51.4224),
               vec4(254.584, 225.632, 100.872, 155.1248),
               vec4(146.864, -1046.064, 28.368, 226.52),
               vec4(-103.872, 6477.48, 30.624, 321.464),
               vec4(-1211.952, -335.96, 36.792, 288.9216)
          }
     },

     ["Police"] = {
          minPlayer   = 7,
          Cooldown    = (3 * 60 * 1000),
          RestoreTime = (1 * 60 * 1000),
          Distance    = 110,
          category    = 16,
          Sprite      = 60,
          Col         = 46,
          size        = 1.2,
          Reward      = { min = 4, max = 7 },
          coords      = {
               vec4(448.4283, -975.5879, 29.6896, 170.7769)
          }
     }
}

Loc                     = {}
