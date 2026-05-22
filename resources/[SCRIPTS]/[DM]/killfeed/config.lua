Config = {}

Config.ShowTime = 8000
Config.MaxLines = 7                                   

Config.DisplayHeadshots = true                        
Config.DisplayNoScopes = true                         
Config.DisplayDriveByIcons = true                     

Config.DisplayJoinLeave = false                       -- Whether or not to display connections and disconnections in the killfeed
Config.JoinLeaveColour = { r = 30, g = 100, b = 210 } -- The colour of the name of the person who left/joined
Config.ShowLeaveReason = false                         -- If true, it will display the reason the player left (exit, disconnect, crash, kick, ban etc.), otherwise it'll just say 'NAME left the server' regardless of the reason

-- These are the default victim/killer colours (rgb)
Config.KillerColour = {
    Player = { r = 0, g = 500, b = 0 },
    NPC = { r = 0, g = 160, b = 0 },
}
Config.VictimColour = {
    Player = { r = 500, g = 0, b = 0 },
    NPC = { r = 219, g = 66, b = 66 },
}

Config.IncludeAI = true 
Config.AddAIPrefix = true
Config.AIPrefix = "NPC "
Config.UseRandomAINames = true 

Config.IncludeAnimals = false  
Config.AddAnimalPrefix = false
Config.AnimalPrefix = "[Animal] "
Config.AddAnimalSuffix = true      

Config.Proximity = false           -- Whether or not to use proximity checks (aka only show kills close by).
Config.ProximityRange = 424.0      -- The max distance in meters the player can be from the victim and it displaying the kill. 424 meters is the max extent of the default client scope/culling in onesync

Config.ShowKillDistance = 1       -- 0/false = don't show at all, 1 = show for weapons with the showDist option set to true (by default only snipers), 2 = show distance on every kill
Config.KillDistanceUnit = "meters" -- "meters" or "feet"
Config.KillDistanceColour = { r = 255, g = 255, b = 255 }

-- Whether or not to use ace permissions. When setting the permissions you should set the 'killfeed.display' ace to allow. If the Config.Proximity is set to true, then this will allow those with permissions to see all kills while regular players only see kills within the proximity range.
-- Example: `add_ace admin "killfeed.display" allow` in server.cfg or permissions.cfg or `ExecuteCommand('add_ace admin killfeed.display allow')` in a script that can change permissions (both without the ``)
Config.UsePermissions = false

-- Easter eggs names, they can only appear on NPCs such as when you kill an animal or pedestrian.
Config.UseEasterEggs = false
Config.EasterEggs = { "blattersturm", "nihonium", "Disquse", "gottfriedleibniz", "PichotM", "LWSS", "Hellslicer",
    "TomGrobbe", "NCG", "Mads" } -- These are some of the top contributors to the fivem project on github (+ 2 others), you can replace them with your own if you desire.

Config.ToggleCommand = true      -- Whether or not to add a command for the client to toggle the killfeed on/off

Config.UseGroups = false
Config.Groups = {
    -- This is just an example of a group/team/gang/whatever, you can add as many as you want, or even create them dynamically by calling the CreateGroup function (server export).
    ['vagos'] = {                                -- This is the identifier of the group, it must be unique
        tag = "[VAGOS] ",                        -- This is the "tag", the string that gets put in front of the player's name
        tagColour = { r = 150, g = 0, b = 150 }, -- This is the colour of said "tag"
        colour = { r = 250, g = 200, b = 10 },   -- This is the colour of the player's name
        members = {}                             -- Leave this empty, it's just there to configure stuff correctly
    },
    ['police'] = {                               -- This is the identifier of the group, it must be unique
        tag = "[POLICE] ",                       -- This is the "tag", the string that gets put in front of the player's name
        tagColour = { r = 0, g = 0, b = 255 },   -- This is the colour of said "tag"
        colour = { r = 0, g = 0, b = 255 },      -- This is the colour of the player's name
        members = {}                             -- Leave this empty, it's just there to configure stuff correctly
    },
    ['mechanic'] = {                             -- This is the identifier of the group, it must be unique
        tag = "[VAGOS] ",                        -- This is the "tag", the string that gets put in front of the player's name
        tagColour = { r = 250, g = 250, b = 0 }, -- This is the colour of said "tag"
        colour = { r = 250, g = 250, b = 0 },    -- This is the colour of the player's name
        members = {}                             -- Leave this empty, it's just there to configure stuff correctly
    }
}

-- Read the documentation on how to utilize lobbies
Config.UseLobbies = false
Config.Lobbies = {
    -- Example:
    --[[
    ['general'] = {
        members = {}
    }
    ]] --
}
