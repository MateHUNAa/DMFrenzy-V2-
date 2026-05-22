ESX                   = exports['es_extended']:getSharedObject()
mCore                 = exports["mCore"]:getSharedObj()
local showKillfeed    = true
local deathOverwrite  = false
local ignoreNextDeath = false
local recentDeaths    = {}
local damageIndex     = {
    fatal = 6,
    weapon = 7
}


local myKillstreak = 0

exports("getKS", (function()
    return myKillstreak
end))


if Config.TestMode then
    RegisterCommand('testEmbed', function(source)
        TriggerServerEvent('matehunkd:testEmbed')
    end)
end


--
-- Toggle UI
--

local toggle = false
-- RegisterCommand("stats", function(source, args, raw)
--     TriggerEvent('matehunkd:togglekd')
-- end)

RegisterNetEvent('dmf->HideHUD', function()
    SendNUIMessage({
        type = 'mVisibility',
        state = false
    })
    toggle = false
end)

-- RegisterNetEvent('matehunkd:togglekd', function()
--     SendNUIMessage({
--         type = 'mVisibility',
--         state = toggle
--     })
--     toggle = not toggle
-- end)

RegisterNetEvent("mate:ui:show", (function()
    SendNUIMessage({
        type = 'mVisibility',
        state = true
    })
    toggle = true
end))

RegisterNetEvent("mate:ui:hide", (function()
    SendNUIMessage({
        type = 'mVisibility',
        state = false
    })
    toggle = false
end))

RegisterKeyMapping('stats', 'Show/UnShow KD UI', 'keyboard', Config.ToggleUiKey)

--
-- Handle data between UI
--

RegisterNUICallback(":domLoaded", function(body, cb)
    while not ESX.IsPlayerLoaded() do Wait(300) end

    Wait(455)

    ESX.TriggerServerCallback("matehunkd:getKd", function(data)
        if type(data) ~= "table" then return print("Expected table got " .. tostring(type(data))) end

        SendNUIMessage({
            type = "mLoadData",
            data = {
                kills      = data["kills"],
                deaths     = data["deaths"],

                killstreak = 0,
                highestKS  = 0
            }
        })
    end)
end)

Citizen.CreateThread((function()
    while not ESX.IsPlayerLoaded() do Wait(300) end

    Wait(455)

    ESX.TriggerServerCallback("matehunkd:getKd", function(data)
        if type(data) ~= "table" then return print("Expected table got " .. tostring(type(data))) end

        SendNUIMessage({
            type = "mLoadData",
            data = {
                kills      = data["kills"],
                deaths     = data["deaths"],

                killstreak = 0,
                highestKS  = 0
            }
        })
    end)
end))


--[[

interface playerdata {
  kills: number;
  deaths: number;

  killstreak: number;
  highestKS: number;
}
]]


RegisterNetEvent('mate-kd:client:updateKillstreak', function(new)
    myKillstreak = new
end)

exports('getKS', function()
    return myKillstreak
end)

RegisterNetEvent("matehunkd:handleNewKill", function()
    ESX.TriggerServerCallback("matehunkd:getKd", function(data)
        if data ~= false then
            Wait(500)
            SendNUIMessage({
                type = "mLoadData",
                data = {
                    kills  = data["kills"],
                    deaths = data["deaths"],


                    killstreak = myKillstreak or 0,
                    highestKS  = data["highestKS"] or 0,
                }
            })
        end
    end)
end)




local weapons = {
    -- Melee --
    [-1569615261] = { image = "unarmed", canHeadshot = false },       -- WEAPON_UNARMED       - Unarmed
    [-1716189206] = { image = "knife", canHeadshot = false },         -- WEAPON_KNIFE         - Knife
    [1737195953]  = { image = "nightstick", canHeadshot = false },    -- WEAPON_NIGHTSTICK    - Nightstick
    [1317494643]  = { image = "hammer", canHeadshot = false },        -- WEAPON_HAMMER        - Hammer
    [-1786099057] = { image = "bat", canHeadshot = false },           -- WEAPON_BAT           - Bat
    [-2067956739] = { image = "crowbar", canHeadshot = false },       -- WEAPON_CROWBAR       - Crowbar
    [1141786504]  = { image = "golfclub", canHeadshot = false },      -- WEAPON_GOLFCLUB      - Golfclub
    [-102323637]  = { image = "bottle", canHeadshot = false },        -- WEAPON_BOTTLE        - Bottle
    [-1834847097] = { image = "dagger", canHeadshot = false },        -- WEAPON_DAGGER        - Dagger
    [-102973651]  = { image = "hatchet", canHeadshot = false },       -- WEAPON_HATCHET       - Hatchet
    [-656458692]  = { image = "knuckle", canHeadshot = false },       -- WEAPON_KNUCKLE       - Knuckle Duster
    [-581044007]  = { image = "machete", canHeadshot = false },       -- WEAPON_MACHETE       - Machete
    [-1951375401] = { image = "flashlight", canHeadshot = false },    -- WEAPON_FLASHLIGHT    - Flashlight
    [-538741184]  = { image = "switch_blade", canHeadshot = false },  -- WEAPON_SWITCHBLADE   - Switch Blade
    [-853065399]  = { image = "battleaxe", canHeadshot = false },     -- WEAPON_BATTLEAXE     - Battleaxe
    [-1810795771] = { image = "poolcue", canHeadshot = false },       -- WEAPON_POOLCUE       - Poolcue
    [419712736]   = { image = "wrench", canHeadshot = false },        -- WEAPON_WRENCH        - Wrench
    [940833800]   = { image = "stone_hatchet", canHeadshot = false }, -- WEAPON_STONE_HATCHET - Stone Hatchet
    [1703483498]  = { image = "candy_cane", canHeadshot = false },    -- WEAPON_CANDYCANE     - Candy Cane

    -- Handguns --
    [453432689]   = { image = "pistol", canDriveBy = true },                         -- WEAPON_PISTOL            - Pistol
    [-1075685676] = { image = "pistol_mk2", canDriveBy = true },                     -- WEAPON_PISTOL_MK2        - Pistol Mk II
    [839574184]   = { image = "pistol_mk2", canDriveBy = true },                     -- WEAPON_MATEPIST        - Pistol Mk II
    [1593441988]  = { image = "combat_pistol", canDriveBy = true },                  -- WEAPON_COMBATPISTOL      - Combat Pistol
    [-1716589765] = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_PISTOL50          - Pistol 50
    [1498862683]  = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_FNX45          - Pistol 50
    [-1660415663]  = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_DMFCOMBAT          - fiveseven
    [148382568]  = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_SFXD       - Springfieldgeci
    [-346444699]  = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_vipglock       - Springfieldgeci
    [1961667481]  = { image = "pistol_50", canDriveBy = true },                      -- WEAPON_deadnight      - Springfieldgeci

    
    [-1076751822] = { image = "sns_pistol", canDriveBy = true },                     -- WEAPON_SNSPISTOL         - SNS Pistol
    [-2009644972] = { image = "snspistol_mk2", canDriveBy = true },                  -- WEAPON_SNSPISTOL_MK2     - SNS Pistol Mk II
    [-771403250]  = { image = "heavy_pistol", canDriveBy = true },                   -- WEAPON_HEAVYPISTOL       - Heavy Pistol
    [137902532]   = { image = "vintage_pistol", canDriveBy = true },                 -- WEAPON_VINTAGEPISTOL     - Vintage Pistol
    [727643628]   = { image = "ceramic", canDriveBy = true },                        -- WEAPON_CERAMICPISTOL     - Ceramic Pistol
    [-598887786]  = { image = "marksman_pistol", canDriveBy = true },                -- WEAPON_MARKSMANPISTOL    - Marksman Pistol
    [-1045183535] = { image = "revolver", canDriveBy = true },                       -- WEAPON_REVOLVER          - Revolver
    [-879347409]  = { image = "revolver_mk2", canDriveBy = true },                   -- WEAPON_REVOLVER_MK2      - Heavy Revolver Mk II
    [-1746263880] = { image = "double_action", canDriveBy = true },                  -- WEAPON_DOUBLEACTION      - Double-Action Revolver
    [-1853920116] = { image = "navy_revolver", canDriveBy = true },                  -- WEAPON_NAVYREVOLVER      - Navy Revolver
    [1470379660]  = { image = "perico_pistol", canDriveBy = true },                  -- WEAPON_GADGETPISTOL      - Perico Pistol
    [465894841]   = { image = "wm29_pistol", canDriveBy = true },                    -- WEAPON_PISTOLXM3         - WM 29 Pistol
    [584646201]   = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_APPISTOL          - AP Pistol
    [-1965422994] = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_CHUCKYAPPISTOL          - AP Pistol
    [1221637313]  = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_TEST         - AP Pistol
    [840389565]   = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_TOXICAP         - AP Pistol
    [620689427]   = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_RICKAP         - AP Pistol
    [916101953]   = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_COLOURAP          - AP Pistol
    [-400796249]  = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_CIGANY         - AP Pistol
    [-534177399]  = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_VIP        - AP Pistol
    [-1833458612] = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_RIMEAP        - AP Pistol
    [-1010218779] = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_Glock18        - AP Pistol
    [837751478] = { image = "ap_pistol", canDriveBy = true },                      -- WEAPON_5genglock       - AP Pistol

    [911657153]   = { image = "stun_gun", canDriveBy = true, canHeadshot = false },  -- WEAPON_STUNGUN           - Stun Gun
    [1171102963]  = { image = "stun_gun", canDriveBy = true, canHeadshot = false },  -- WEAPON_STUNGUN_MP        - Stun Gun MP
    [1198879012]  = { image = "flare_gun", canDriveBy = true, canHeadshot = false }, -- WEAPON_FLAREGUN          - Flare Gun
    [-1355376991] = { image = "raypistol", canHeadshot = false },                    -- WEAPON_RAYPISTOL         - Up-n-Atomizer

    -- Submachine Guns --
    [324215364]   = { image = "micro_smg", canDriveBy = true },      -- WEAPON_MICROSMG      - Micro SMG
    [-619010992]  = { image = "machine_pistol", canDriveBy = true }, -- WEAPON_MACHINEPISTOL - Machine Pistol
    [-1121678507] = { image = "mini_smg", canDriveBy = true },       -- WEAPON_MINISMG       - Mini SMG
    [736523883]   = { image = "smg" },                               -- WEAPON_SMG           - SMG
    [2024373456]  = { image = "smg_mk2" },                           -- WEAPON_SMG_MK2       - SMG Mk II
    [-270015777]  = { image = "assault_smg" },                       -- WEAPON_ASSAULTSMG    - Assault SMG
    [171789620]   = { image = "combat_pdw" },                        -- WEAPON_COMBATPDW     - Combat PDW
    [-1660422300] = { image = "mg" },                                -- WEAPON_MG            - MG
    [2144741730]  = { image = "combat_mg" },                         -- WEAPON_COMBATMG      - Combat MG
    [-608341376]  = { image = "combat_mg_mk2" },                     -- WEAPON_COMBATMG_MK2  - Combat MG Mk II
    [1627465347]  = { image = "gusenberg" },                         -- WEAPON_GUSENBERG     - Gusenberg
    [1198256469]  = { image = "raycarbine" },                        -- WEAPON_RAYCARBINE    - Unholy Hellbringer

    -- Assault Rifles --
    [-1074790547] = { image = "assault_rifle" },       -- WEAPON_ASSAULTRIFLE          - Assault Rifle
    [-1839318280] = { image = "assault_rifle" },       -- WEAPON_PURPLEAK       - Assault Rifle
    [961495388]   = { image = "assault_rifle_mk2" },   -- WEAPON_ASSAULTRIFLE_MK2      - Assault Rifle Mk II
    [-2084633992] = { image = "carbine_rifle" },       -- WEAPON_CARBINERIFLE          - Carbine Rifle
    [-86904375]   = { image = "carbine_rifle_mk2" },   -- WEAPON_CARBINERIFLE_MK2      - Carbine Rifle Mk II
    [-1357824103] = { image = "advanced_rifle" },      -- WEAPON_ADVANCEDRIFLE         - Advanced Rifle
    [-1063057011] = { image = "special_carbine" },     -- WEAPON_SPECIALCARBINE        - Special Carbine
    [-1768145561] = { image = "special_carbine_mk2" }, -- WEAPON_SPECIALCARBINE_MK2    - Special Carbine Mk II
    [2132975508]  = { image = "bullpup_rifle" },       -- WEAPON_BULLPUPRIFLE          - Bullpup Rifle
    [-2066285827] = { image = "bullpup_rifle_mk2" },   -- WEAPON_BULLPUPRIFLE_MK2      - Bullpup Rifle Mk II
    [1649403952]  = { image = "compact_rifle" },       -- WEAPON_COMPACTRIFLE          - Compact Rifle
    [-1658906650] = { image = "military_rifle" },      -- WEAPON_MILITARYRIFLE         - Military Rifle
    [-947031628]  = { image = "heavy_rifle" },         -- WEAPON_HEAVYRIFLE            - Heavy Rifle
    [-774507221]  = { image = "service_rifle" },       -- WEAPON_TACTICALRIFLE         - Service Carbine

    -- Sniper Rifles --
    [100416529]   = { image = "sniper_rifle", canNoScope = true, showDist = true },       -- WEAPON_SNIPERRIFLE       - Sniper Rifle
    [205991906]   = { image = "heavy_sniper", canNoScope = true, showDist = true },       -- WEAPON_HEAVYSNIPER       - Heavy Sniper
    [177293209]   = { image = "heavy_sniper_mk2", canNoScope = true, showDist = true },   -- WEAPON_HEAVYSNIPER_MK2   - Heavy Sniper Mk II
    [-952879014]  = { image = "marksman_rifle", canNoScope = true, showDist = true },     -- WEAPON_MARKSMANRIFLE     - Marksman Rifle
    [1785463520]  = { image = "marksman_rifle_mk2", canNoScope = true, showDist = true }, -- WEAPON_MARKSMANRIFLE_MK2 - Marksman Rifle Mk II
    [1853742572]  = { image = "precision_rifle", canNoScope = true, showDist = true },    -- WEAPON_PRECISIONRIFLE    - Precision Rifle

    -- Shotguns --
    [487013001]   = { image = "pump_shotgun" },          -- WEAPON_PUMPSHOTGUN       - Pump Shotgun
    [1432025498]  = { image = "pump_shotgun_mk2" },      -- WEAPON_PUMPSHOTGUN_MK2   - Pump Shotgun Mk II
    [2017895192]  = { image = "sawnoff_shotgun" },       -- WEAPON_SAWNOFFSHOTGUN    - Sawnoff Shotgun
    [-1654528753] = { image = "bullpup_shotgun" },       -- WEAPON_BULLPUPSHOTGUN    - Bullpup Shotgun
    [-494615257]  = { image = "assault_shotgun" },       -- WEAPON_ASSAULTSHOTGUN    - Assault Shotgun
    [-1466123874] = { image = "musket" },                -- WEAPON_MUSKET            - Musket
    [984333226]   = { image = "heavy_shotgun" },         -- WEAPON_HEAVYSHOTGUN      - Heavy Shotgun
    [-275439685]  = { image = "double_barrel_shotgun" }, -- WEAPON_DBSHOTGUN         - Double Barrel Shotgun
    [317205821]   = { image = "sweeper_shotgun" },       -- WEAPON_AUTOSHOTGUN       - Sweeper Shotgun
    [94989220]    = { image = "combat_shotgun" },        -- WEAPON_COMBATSHOTGUN     - Combat Shotgun

    -- Heavy Weapons --
    [-1568386805] = { image = "grenade_launcher" }, -- WEAPON_GRENADELAUNCHER       - Grenade Launcher
    [1305664598]  = { image = "grenade_launcher" }, -- WEAPON_GRENADELAUNCHER_SMOKE - Grenade Launcher Smoke
    [-1312131151] = { image = "rpg" },              -- WEAPON_RPG                   - RPG
    [1119849093]  = { image = "minigun" },          -- WEAPON_MINIGUN               - Minigun
    [2138347493]  = { image = "firework" },         -- WEAPON_FIREWORK              - Firework
    [1834241177]  = { image = "railgun" },          -- WEAPON_RAILGUN               - Railgun
    [1672152130]  = { image = "homing_launcher" },  -- WEAPON_HOMINGLAUNCHER        - Homing Launcher
    [125959754]   = { image = "compact_launcher" }, -- WEAPON_COMPACTLAUNCHER       - Compact Launcher
    [-1238556825] = { image = "rayminigun" },       -- WEAPON_RAYMINIGUN            - Widowmaker
    [-618237638]  = { image = "emp_launcher" },     -- WEAPON_EMPLAUNCHER           - Compact EMP Launcher

    -- Thrown Weapons --
    [-1813897027] = { image = "grenade", canHeadshot = false },           -- WEAPON_GRENADE           - Grenade
    [741814745]   = { image = "sticky_bomb", canHeadshot = false },       -- WEAPON_STICKYBOMB        - Sticky Bomb
    [-1420407917] = { image = "proximity_mine", canHeadshot = false },    -- WEAPON_PROXMINE          - Proximity Mine
    [-1169823560] = { image = "pipebomb", canHeadshot = false },          -- WEAPON_PIPEBOMB          - Pipebomb
    [-37975472]   = { image = "smoke", canHeadshot = false },             -- WEAPON_SMOKEGRENADE      - Smoke Grenade / Tear Gas
    [-1600701090] = { image = "smoke", canHeadshot = false },             -- WEAPON_BZGAS             - BZ Gas
    [615608432]   = { image = "molotov", canHeadshot = false },           -- WEAPON_MOLOTOV           - Molotov
    [101631238]   = { image = "fire_extinguisher", canHeadshot = false }, -- WEAPON_FIREEXTINGUISHER  - Fire Extinguisher (I don't think it is even possible to kill someone with a fire extinguisher)
    [883325847]   = { image = "petrol_can", canHeadshot = false },        -- WEAPON_PETROLCAN         - Petrol Can
    [406929569]   = { image = "petrol_can", canHeadshot = false },        -- WEAPON_FERTILIZERCAN     - Can kill (if ignited), however it returns the fire hash instead, so kinda useless
    [-1168940174] = { image = "petrol_can", canHeadshot = false },        -- WEAPON_HAZARDCAN         - Can't really kill, but I'll just leave it here anyway
    [-135142818]  = { image = "acid_package", canDriveBy = true },        -- WEAPON_ACIDPACKAGE       - Acid Package/Newspaper (only deals 1hp damage)
    [1233104067]  = { image = "flare", canHeadshot = false },             -- WEAPON_FLARE             - Flare
    [600439132]   = { image = "ball", canHeadshot = false },              -- WEAPON_BALL              - Ball (I don't think this does damage)
    [126349499]   = { image = "snowball", canHeadshot = false },          -- WEAPON_SNOWBALL          - Snowball

    -- Other Weapons --
    ['default']   = { image = "unknown", canHeadshot = false, ignoreDeath = false }, -- If the weapon was not spesifed in the list it will fall back on this one
    [-100946242]  = { image = "animal" },                                            -- WEAPON_ANIMAL
    [148160082]   = { image = "cougar" },                                            -- WEAPON_COUGAR                - Mt. Lion and Panthers
    [539292904]   = { image = "explosion", canHeadshot = false },                    -- WEAPON_EXPLOSION             - Explosion
    [-842959696]  = { image = "fall", canHeadshot = false, canSelf = false },        -- WEAPON_FALL                  - Fall damage
    [-544306709]  = { image = "fire", canHeadshot = false, canSelf = false },        -- WEAPON_FIRE                  - Fire
    [-1553120962] = { image = "vehicle", canHeadshot = false },                      -- WEAPON_RUN_OVER_BY_CAR       - Run over by a vehicle
    [133987706]   = { image = "rammed", canHeadshot = false },                       -- WEAPON_RAMMED_BY_CAR         - This is while the victim is also in a vehicle
    [-1833087301] = { image = "electric", canHeadshot = false },                     -- WEAPON_ELECTRIC_FENCE        - Electrocuted
    [-10959621]   = { image = "drowning", canHeadshot = false, canSelf = false },    -- WEAPON_DROWNING              - Drowned
    [1936677264]  = { image = "drowning", canHeadshot = false, canSelf = false },    -- WEAPON_DROWNING_IN_VEHICLE   - Drowned, but in a vehicle
    [-868994466]  = { image = "unknown", canHeadshot = false, canSelf = false },     -- WEAPON_HIT_BY_WATER_CANNON   - Water cannon from firetrucks/RCV's

    -- Vehicle Weapons --
    [-1538179531] = { image = "minigun" },   -- _VEHICLE_WEAPON_MINIGUN_VALKYRIE - Valkyrie miniguns
    [1186503822]  = { image = "buzzard" },   -- VEHICLE_WEAPON_PLAYER_BUZZARD    - Buzzard machinegun
    [-1253095144] = { image = "combat_mg" }, -- VEHICLE_WEAPON_TURRET_BOXVILLE   - Armoured Boxville Turret
    [1155224728]  = { image = "combat_mg" }, -- VEHICLE_WEAPON_TURRET_INSURGENT  - Insurgent
    [729375873]   = { image = "minigun" },   -- VEHICLE_WEAPON_TURRET_LIMO       - Turreted Limo
    [2144528907]  = { image = "combat_mg" }, -- VEHICLE_WEAPON_TURRET_TECHNICAL  - Technical (Rebel pickup-truck with machinegun)

    --ADDONFEGYVEREK
    [1040131248]  = { image = "unicornbat" },
    [920511381]   = { image = "mcbat" },


}





--
-- X killed ( killfeed:player-killed )
--

---@param killer { name: string, identifier: string, netId: number, soruceId: number, type:string, xPlayer: table }
---@param victim { name: string, identifier: string, netId: number, soruceId: number, type:string, xPlayer: table }
---@param headshot boolean
---@param killstreak number
RegisterNetEvent('killfeed:player-killed', function(killer, victim, headshot, killstreak)
    SendNUIMessage({
        type = "player-killed",
        data = {
            killerName = killer.name,
            message    = string.format(Config.notify[killstreak] or Config.notify["default"], victim.name or "NOT FOUND")
        }
    })
end)

--
-- Functions
--

local function GetPedSubType(ped)
    if GetPedType(ped) == 28 then
        return "animal"
    end
    return "human"
end

local function GetNearbyVehicles(coords)
    local handle, entity = FindFirstVehicle()
    local success = nil
    local vehicles = {}
    repeat
        local pos = GetEntityCoords(entity)
        local distance = #(coords - pos)
        if distance < 15.0 then
            vehicles[#vehicles + 1] = entity
        end
        success, entity = FindNextVehicle(handle)
    until not success
    EndFindVehicle(handle)
    return vehicles
end


local function HandleDeath(killerPed, victimPed, weaponHash, isMelee)
    local weapon   = weapons[weaponHash]
    local headshot = false
    local noScoped = false
    local driveBy  = false
    local showDist = false

    if not Config.IncludeAI then
        if not IsPedAPlayer(victimPed) then
            return
        elseif not IsPedAPlayer(killerPed) then
            killerPed = -1
            weaponHash = 'default'
        end
    end

    if not DoesEntityExist(killerPed) or (killerPed == victimPed and weapon.canSelf == false) then
        killerPed = -1
    end

    if weaponHash == 133987706 and (killerPed == victimPed or GetVehiclePedIsIn(killerPed, false) == GetVehiclePedIsIn(victimPed, false)) then
        local victimVeh = GetVehiclePedIsIn(victimPed, false)
        local vehicles = GetNearbyVehicles(GetEntityCoords(victimPed))

        for _index, vehicle in pairs(vehicles) do
            if victimVeh ~= vehicle then
                if HasEntityBeenDamagedByEntity(victimVeh, vehicle, true) then
                    local driver = GetPedInVehicleSeat(vehicle, -1)
                    if driver ~= 0 then
                        killerPed = driver
                        break
                    end
                end
            end
        end
    end

    if weapon.canHeadshot ~= false and not isMelee then
        local found, bone = GetPedLastDamageBone(victimPed)
        if found and (bone == 31086 or bone == 39317) then
            headshot = true
        end
    end

    showDist = Config.ToggleDistanceMoney

    -- TODO: Handle Distance Money on kill.

    local killer = {}
    if killerPed == -1 then
        killer.netId = 0
    else
        killer.netId = PedToNet(killerPed)
        if IsPedAPlayer(killerPed) then
            killer.type = "player"
            killer.sourceId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(killerPed))

            if Config.DisplayNoScopes and weapon.canNoScope and not IsFirstPersonAimCamActive() then
                noScoped = true
            end
        else
            killer.type = "npc"
            killer.gender = IsPedMale(killerPed) and "male" or "female"
            killer.pedType = GetPedSubType(killerPed)
        end
    end

    local victim = {}
    victim.netId = PedToNet(victimPed)
    if IsPedAPlayer(victimPed) then
        victim.type = "player"
        victim.sourceId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(victimPed))
    else
        victim.type = "npc"
        victim.gender = IsPedMale(victimPed) and "male" or "female"
        victim.pedType = GetPedSubType(victimPed)
    end

    if killer.sourceId == victim.sourceId then return end
    TriggerEvent('matehunkd:handleKill', killer, victim, noScoped, headshot, driveBy, showDist, weapon.image, weapon)
    TriggerServerEvent('matehunkd:SaveData', killer, victim, noScoped, headshot, driveBy, showDist, weapon.image, weapon)

    if victim.type == "player" then
        local eventName = (killer.type == "player" and killer.sourceId ~= victim.sourceId)
            and "rime->onPlayerKilled"
            or "rime->onPlayerDied"

        local eventData = {
            noScoped = noScoped,
            headshot = headshot,
            driveBy  = driveBy,
            showDist = showDist,
        }

        TriggerEvent(eventName, killer, victim, eventData)
        TriggerServerEvent(eventName, killer, victim, eventData)

        TriggerEvent("rime->playerDied", killer, victim, eventData)
        TriggerServerEvent("rime->playerDied", killed, victim, eventData)
    end


    if Config.HealOnKill then
        SetEntityHealth(killerPed, 200)
    end

    if Config.ArmourOnKill then
        SetPedArmour(killerPed, 100)
    end
end


local function OnEntityDamage(args)
    local fatal = args[damageIndex.fatal]

    local victim = args[1]
    local killer = args[2]
    local isMelee = (args[12] == 1 and true) or false

    if fatal == 0 then
        if not IsPedAPlayer(args[1]) then
            return
        end

        if not IsEntityAPed(victim) then
            return
        end

        local weaponHash = args[damageIndex.weapon]
        if not weapons[weaponHash] then
            weaponHash = 'default'
        end

        local weapon = weapons[weaponHash]

        LocalPlayer.state:set("InCombat", GetGameTimer())

        if weapon.canHeadshot ~= false and not isMelee then
            local found, bone = GetPedLastDamageBone(args[1])
            if found and (bone == 31086 or bone == 39317) then
                if PlayerPedId() == killer or (not IsPedAPlayer(killer) and NetworkHasControlOfEntity(victim)) then
                    local nVictim = NetworkGetEntityOwner(victim)
                    local victimServerId = GetPlayerServerId(nVictim)
                    TriggerServerEvent("mate-kd:s:registerHeadshot", victimServerId)
                    HandleDeath(killer, victim, weaponHash, isMelee)
                end

                return
            end
        end

        return
    end


    local playerPed = PlayerPedId()

    if not IsEntityAPed(victim) then
        return
    end



    if playerPed == killer or (not IsPedAPlayer(killer) and NetworkHasControlOfEntity(victim)) then
        local weaponHash = args[damageIndex.weapon]

        if not weapons[weaponHash] then
            weaponHash = 'default'
        end

        if weapons[weaponHash].ignoreDeath then
            return
        end

        HandleDeath(killer, victim, weaponHash, isMelee)
        Citizen.Wait(1000)
    end
end


RegisterNetEvent("mate-kd:registerHeadshot", function()
    SetEntityHealth(PlayerPedId(), 0)
end)


-- Events


AddEventHandler('gameEventTriggered', function(event, args)
    if event == "CEventNetworkEntityDamage" then
        OnEntityDamage(args)
    end
end)


RegisterCommand("_hash", (function()
    local weaponHash = GetSelectedPedWeapon(PlayerPedId())

    print(weaponHash)
end), false)
