Config = {
     lan               = "en",
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


Config.CameraPos = vector4(1563.9036, 382.3673, -49.6821, 57.0690)

local PistolLobby = {
     "WEAPON_PISTOL",
     "WEAPON_COMBATPISTOL",
     --[[      "WEAPON_APPISTOL", ]]
     "WEAPON_PISTOL50",
     "WEAPON_SNSPISTOL",
     "WEAPON_SNSPISTOL_MK2",
     "WEAPON_HEAVYPISTOL",
     "WEAPON_VINTAGEPISTOL",
     "WEAPON_CERAMICPISTOL",
     "WEAPON_DMFCOMBAT", -- FiveSeven
     "WEAPON_FNX45",     -- FNX .45 Tactical Pistol
     "WEAPON_SFXD",      -- SpringField
}

Config.Gamemodes = {
     --[[      {
          id             = "bobcat",
          label          = "Bobcat",
          maxPlayers     = 12,
          outPos         = vec4(733.7614, -2017.2220, 29.2826, 271.6361),
          restrictLabel  = { "Minden 🔫", "Ghost 🚗" },
          dimensionRules = {
               ["GhostVehicle"] = true,
          }

     }, ]]
     --[[      {
          id             = "humi",
          label          = "Humane",
          maxPlayers     = 12,
          outPos         = vector4(2753.9902, 3457.9988, 55.8979, 250.0081),
          restrictLabel  = { "Minden 🔫", "🚗 Tiltott" },
          dimensionRules = {}
     }, ]]
     {
          id             = "ceo",
          label          = "CEO",
          maxPlayers     = 12,
          outPos         = vec4(-76.8476, -827.4945, 243.3859, 332.2271),
          restrictLabel  = { "Minden 🔫" },
          dimensionRules = {
               ["DenyVehicles"]     = true,
               ["LeaveAfterKilled"] = true,
               ["RespawnFromList"]  = {
                    vec4(-76.8476, -827.4945, 243.3859, 332.2271),
               },
               ["WeaponDurability"] = true,
          }

     },
     {
          id             = "ffa1",
          label          = "FFA #1",
          maxPlayers     = 12,
          outPos         = vec4(4101.784, -0.392, 47.808, 1.0),
          restrictLabel  = { "Minden 🔫" },
          dimensionRules = {
               ["DenyVehicles"]     = true,
               ["RespawnFromList"]  = {
                    vec4(4054.824, -0.752, 42.664, 202.9147491455),
                    vec4(4061.144, -17.44, 42.664, 207.72676086426),
                    vec4(4070.008, -27.136, 42.664, 234.18185424804),
                    vec4(4084.272, -33.736, 42.664, 256.84860229492),
                    vec4(4096.656, -34.872, 42.664, 273.71203613282),
                    vec4(4114.624, -29.184, 42.664, 300.96868896484),
                    vec4(4125.328, -19.68, 42.664, 321.47061157226),
                    vec4(4132.168, -4.688, 42.664, 349.6329650879),
                    vec4(4131.0, 15.968, 42.664, 14.523327827454),
                    vec4(4123.08, 30.008, 42.664, 45.29252243042),
                    vec4(4106.104, 41.64, 42.664, 65.935859680176),
                    vec4(4099.496, 36.872, 42.664, 220.8177947998),
                    vec4(4112.968, 29.552, 42.664, 240.85620117188),
                    vec4(4124.536, 22.528, 45.44, 210.7585144043),
                    vec4(4126.928, 17.736, 45.4, 187.55824279786),
                    vec4(4106.656, 27.256, 42.68, 151.53408813476),
                    vec4(4101.352, 16.968, 42.736, 82.314453125),
                    vec4(4088.704, 19.352, 42.664, 128.84928894042),
                    vec4(4090.112, 9.248, 42.728, 166.865234375),
                    vec4(4085.04, 1.08, 42.664, 77.207542419434),
                    vec4(4082.48, -4.056, 42.736, 65.603302001954),
                    vec4(4074.024, -4.632, 42.672, 155.28427124024),
                    vec4(4068.456, -19.888, 42.664, 307.51733398438),
                    vec4(4076.072, -22.12, 42.664, 228.9446258545),
                    vec4(4086.752, -27.352, 42.664, 298.87420654296),
                    vec4(4094.808, -18.336, 42.664, 31.463237762452),
                    vec4(4096.376, -14.352, 42.736, 17.872854232788),
                    vec4(4106.872, -12.584, 42.664, 292.42681884766),
                    vec4(4115.336, -10.04, 42.664, 112.19889068604),
                    vec4(4116.176, -12.104, 45.232, 220.0709991455),
                    vec4(4121.44, -12.624, 42.664, 13.8527469635),
                    vec4(4119.808, -4.384, 42.664, 13.944187164306),
                    vec4(4127.976, 1.736, 42.664, 22.00659942627),
                    vec4(4122.136, 13.208, 42.664, 32.54919052124),
                    vec4(4119.688, 25.128, 42.664, 49.737014770508),
                    vec4(4123.592, 23.584, 45.456, 189.4528503418),
                    vec4(4127.608, 14.856, 48.216, 97.111068725586),
                    vec4(4127.08, 12.328, 50.76, 187.57446289062),
                    vec4(4127.472, 3.408, 50.76, 179.59759521484),
                    vec4(4114.936, 0.304, 47.76, 87.47258758545),
                    vec4(4109.392, -2.184, 47.744, 160.6156463623),
                    vec4(4103.208, -2.752, 47.8, 29.27840423584),
                    vec4(4096.544, -2.424, 47.808, 182.54582214356),
                    vec4(4093.832, -9.664, 45.656, 197.3314819336),
                    vec4(4092.56, -15.328, 45.672, 134.58668518066),
                    vec4(4085.048, -20.848, 45.224, 54.304069519042),
                    vec4(4080.256, -17.408, 45.232, 54.304069519042),
                    vec4(4076.656, -9.376, 45.216, 14.1535654068),
                    vec4(4076.96, 1.44, 45.232, 10.774166107178),
                    vec4(4079.104, 14.68, 42.664, 304.40301513672),
                    vec4(4087.544, 16.6, 42.664, 274.37414550782),
               },
               ["WeaponDurability"] = true,
          }
     },
     {
          id             = "FFA2",
          label          = "FFA #2",
          maxPlayers     = 12,
          outPos         = vec4(-2287.8820, 1430.9620, 82.7673, 1.1),
          restrictLabel  = { "AP/TEC9 ❌", "🚗 Tiltott", "Backroom 🚪" },
          dimensionRules = {
               ["DenyVehicles"]     = true,
               ["AllowedWeapons"]   = PistolLobby,
               ["RespawnFromList"]  = {
                    vec4(-2273.848, 1417.16, 80.92, 42.79277420044),
                    vec4(-2302.16, 1416.856, 80.92, 299.90530395508),
                    vec4(-2302.24, 1424.984, 80.92, 316.6510925293),
                    vec4(-2302.416, 1432.896, 80.92, 313.93045043946),
                    vec4(-2290.168, 1432.816, 80.92, 67.644020080566),
               },
               ["LeaveAfterKilled"] = true,
               ["WeaponDurability"] = true,
          }
     },
     {
          id             = "weaponShop",
          label          = "Fegyver Bolt",
          maxPlayers     = 12,
          outPos         = vec4(228.6544, -799.6544, 30.5912, 335.2873),
          restrictLabel  = { "AP/TEC9 ❌", "Ghost 🚗" },
          dimensionRules = {
               ["GhostVehicle"]     = true,
               ["AllowedWeapons"]   = PistolLobby,
               ["WeaponDurability"] = true
          }
     },
     {
          id             = "freeroam",
          label          = "Freeroam",
          maxPlayers     = 100,
          outPos         = vec4(228.6544, -799.6544, 30.5912, 335.2873),
          restrictLabel  = { "Minden 🔫", "Rablás ✅", "Bounty 💀" },
          dimensionRules = {
               ["RobberyAllowed"]         = true,
               ["WeaponDurability"]       = true,
               ["RemoveVehicleAfterDie2"] = true
          }
     },
     --[[      {
          id             = "carfight1",
          label          = "Car Fight #1",
          maxPlayers     = 22,
          outPos         = vector4(-1465.92, -3048.152, 12.944, 181.1824),
          restrictLabel  = { "0km/h", "Minden 🔫" },
          dimensionRules = {
               ["RemoveVehicleAfterDie"] = true,
               ["onSpawnGiveVehicle"] = "bolide",
               ["0kmph"] = true,
               ["RespawnInArea"] = {
                    coords = vector4(-1465.92, -3048.152, 12.944, 181.1824),
                    radius = 80.0
               }
          }

     },
     {
          id             = "carfight2",
          label          = "Car Fight #2",
          maxPlayers     = 22,
          outPos         = vector4(-1465.92, -3048.152, 12.944, 181.1824),
          restrictLabel  = { "AP/TEC9 ❌", "0km/h" },
          dimensionRules = {
               ["RemoveVehicleAfterDie"] = true,
               ["onSpawnGiveVehicle"]    = "bolide",
               ["0kmph"]                 = true,
               ["AllowedWeapons"]        = PistolLobby,
               ["RespawnInArea"]         = {
                    coords = vector4(-1465.92, -3048.152, 12.944, 181.1824),
                    radius = 80.0
               }
          }

     },
     {
          id             = "carfight3",
          label          = "Car Fight #3",
          maxPlayers     = 22,
          outPos         = vector4(-1465.92, -3048.152, 12.944, 181.1824),
          restrictLabel  = { "Minden 🔫" },
          dimensionRules = {
               ["RemoveVehicleAfterDie"] = true,
               ["onSpawnGiveVehicle"] = "bolide",
               ["RespawnInArea"] = {
                    coords = vector4(-1465.92, -3048.152, 12.944, 181.1824),
                    radius = 80.0
               }
          }

     }, ]]
}

Loc = {}
