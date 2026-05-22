Config = {}



--------------------------------
-- [ License Key ]

Config.LicenseKey = "matehun-A2nHeTmBTc0WTimxlbeBk8blbfiGPf1rvMYy1HdDi6vqt2g1"


--------------------------------
-- [Date Format]

Config.DateFormat = '%H:%M' -- To change the date format check this website - https://www.lua.org/pil/22.1.html

-- [Staff Groups]

Config.StaffGroups = {

	"A TETVES JO KURVA ANYAD"
}

--------------------------------
-- [Banned Words]

Config.BadWords = {
	".gg",
	".io",
	".hu",
	".com",
	".org",
	".net",
	".eu",
	"1.",
	"2.",
	"3.",
	"4.",
	"5.",
	"6.",
	"7.",
	"8.",
	"9.",
	"www.",
	"www",
	"http",
	"https",
	"dc.gg",
	"discord.io",
	"discord.io/",
	"kurva",
	"anya",
	"anyád",
	"badword3",
}

Config.kickmessage = '[ ~b~WORD FILTER ~w~]: You have been ~r~kicked~w~ from this server because used a ~r~bad~w~ word!'
Config.mode = 'delete' -- delete = del msg | kick = Kick from the server
--------------------------------
-- [Clear Player Chat]

Config.AllowPlayersToClearTheirChat = true

Config.ClearChatCommand = 'clear'

--------------------------------
-- [Lockdown chat]

Config.LockdownChatCommand = 'lockdown'

--------------------------------
-- [Mute Player]

Config.MuteCommand = 'mute'
Config.unMuteCommand = 'unmute'
--------------------------------
-- [Staff]

Config.EnableStaffCommand = true

Config.StaffCommand = 'asay'

Config.AllowStaffsToClearEveryonesChat = true

Config.ClearEveryonesChatCommand = 'clearall'

-- [Staff Only Chat]

Config.EnableStaffOnlyCommand = true

Config.StaffOnlyCommand = 'a'

--------------------------------
-- [Advertisements]

Config.EnableAdvertisementCommand = false

Config.AdvertisementCommand = 'ad'

Config.AdvertisementPrice = 0

Config.AdvertisementCooldown = 5 -- in minutes

--------------------------------
-- [Twitch]

Config.EnableTwitchCommand = false

Config.TwitchCommand = 'twitch'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.TwitchList = {
	'discord:600278775011213312' -- Example, change this
}

--------------------------------
-- [Youtube]

Config.EnableYoutubeCommand = false

Config.YoutubeCommand = 'youtube'

-- Types of identifiers: steam: | license: | xbl: | live: | discord: | fivem: | ip:
Config.YoutubeList = {
	'discord:600278775011213312' -- Example, change this
}

--------------------------------
-- [Twitter]

Config.EnableTwitterCommand = false

Config.TwitterCommand = 'twitter'

Config.TwitterCooldown = 5 -- in minutes

--------------------------------
-- [Police]

Config.EnablePoliceCommand = false

Config.PoliceCommand = 'police'

Config.PoliceJobName = 'police'

--------------------------------
-- [Ambulance]

Config.EnableAmbulanceCommand = false

Config.AmbulanceCommand = 'ambulance'

Config.AmbulanceJobName = 'ambulance'

--------------------------------
-- [OOC]

Config.EnableOOCCommand = true

Config.OOCCommand = ''

Config.OOCDistance = 20.0

--------------------------------
