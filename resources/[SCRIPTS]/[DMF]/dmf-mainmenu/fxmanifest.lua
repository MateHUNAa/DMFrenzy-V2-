shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'MateHUN [mhScripts]'
description 'Template used mCore'
version '1.0.0'

shared_script "@clientloader/shared.lua"

shared_scripts {
    "shared/**.*"
}

server_scripts {
    "server/functions.lua",
    "server/main.lua",
}

-- client_scripts {
--     "client/functions.lua",
--     "client/main.lua",
-- }

clientloader {
    "client/functions.lua",
    "client/main.lua",
    "client/gamemode.lua",
    "client/inventory.lua",
}


server_script "@oxmysql/lib/MySQL.lua"
shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

dependency {
    'mCore',
    'oxmysql',
    'ox_lib',
    'mate-dimManager',
    "mate-kd",
    "dmf-core"
}


escrow_ignore {
    'shared/config.lua',
    '**/*.editable.lua'
}



files {
    "html/index.html",
    "html/assets/*.js",
    "html/assets/*.css",
    "html/assets/*.png",
    "html/*.png",
    "html/*.wav",
    "html/*.mp3",
    "html/*.ttf",
    
}


ui_page "html/index.html"
