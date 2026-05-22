Config = {}
Config.MySQL = 'oxmysql' -- oxmysql, mysql-async, ghmattimysql
Config.Volume = 0.10 -- Notification sound volume
Config.DefaultTime = 5000 -- Default notification time if not defined in the event
Config.SettingsPage = {
    command = {
        enable = true,
        name = "nsettings"
    },
    key = {
        enable = false,
        keyNum = 20, -- Z By default https://docs.fivem.net/docs/game-references/controls/
    },
}
Config.DefaultNotificationPosition = "top-center" -- top-left, top-center, top-right, bottom-left, bottom-center, bottom-right
Config.EnableSoundByDefault = true

Config.Translation = {
    ["SETTINGS_TEXT"] = 'Please select a position to adjust notification position.',
    ["HIDE_NOTIFY"] = 'Hide Notify',
    ["SHOW_NOTIFY"] = 'Show Notify',
    ["ENABLE_SOUND"] = 'Enable Sound',
    ["DISABLE_SOUND"] = 'Disable Sound',
}

Config.Themes = { -- Edit only if you know what are you doing! More information can be find in documentation
["server"] = {
    background = {
        color = 'linear-gradient(180deg, rgba(30, 31, 34, 0.9) 0%, rgba(44, 47, 54, 0.7) 100%)',
    },
    title = {
        color = '#FFFFFF',
        textShadow = '0px 2px 8px rgba(255, 255, 255, 0.5)',
    },
    iconBox = {
        overlayColor = '#2E8BFF',
        shadow = '0px 4px 12px rgba(46, 139, 255, 0.5)',
    },
    timerBar = {
        trailColor = '#4A4A4A',
        color = '#2E8BFF',
        shadow = '0px 0px 15px #2E8BFF',
    },
    defaultHeader = 'SERVER',
    icon = 'server',
},

["announcement"] = {
    background = {
        color = 'linear-gradient(180deg, rgba(26, 13, 0, 0.8) 0%, rgba(17, 19, 22, 0.6) 524.5%)',
    },
    title = {
        color = '#FFFFFF', -- világító fehér szín
        textShadow = 'rgba(255, 255, 255, 0.5)',
    },
    iconBox = {
        overlayColor = '#FFFFFF', -- fekete helyett fehér
        shadow = 'rgba(255, 255, 255, 0.35)', -- fehér árnyék
    },
    timerBar = {
        trailColor = '#FFFFFF29', -- fehér
        color = '#FFFFFF', -- fehér
        shadow = '0px 0px 27px #FFFFFF',
    },
    defaultHeader = 'ANNOUNCEMENT',
    icon = 'announcement',
},

["info"] = {
    background = {
        color = 'rgba(0, 0, 0, 0.9)',
    },
    title = {
        color = '#FFFFFF',
        textShadow = 'rgba(255, 255, 255, 0.5)',
    },
    iconBox = {
        overlayColor = '#FFFFFF', -- fekete helyett fehér
        shadow = 'rgba(255, 255, 255, 0.35)', -- fehér árnyék
    },
    timerBar = {
        trailColor = '#FFFFFF29', -- fehér
        color = '#FFFFFF', -- fehér
        shadow = '0px 0px 27px #FFFFFF',
    },
    defaultHeader = 'INFO',
    icon = 'info',
},

["status"] = {
    background = {
        color = 'linear-gradient(180deg, rgba(2, 3, 9, 0.8) 0%, rgba(17, 19, 22, 0.6) 524.5%)',
    },
    title = {
        color = '#FFFFFF',
        textShadow = 'rgba(255, 255, 255, 0.5)',
    },
    iconBox = {
        overlayColor = '#FFFFFF', -- fekete helyett fehér
        shadow = 'rgba(255, 255, 255, 0.35)', -- fehér árnyék
    },
    timerBar = {
        trailColor = '#FFFFFF29', -- fehér
        color = '#FFFFFF', -- fehér
        shadow = '0px 0px 27px #FFFFFF',
    },
    defaultHeader = "STATUS",
    icon = 'status',
},

}