shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'
use_experimental_fxv2_oal 'yes'

author 'MateHUN [mhScripts]'
description 'Template used mCore'
version '1.0.0'


shared_scripts {
    "shared/**.*"
}

shared_script "@clientloader/shared.lua"
clientloader {
    "client/functions.lua",

    -- Vehicle
    "client/vehicle/Vehicle.lua",

    -- Utils
    "client/utils/Menu.lua",


    -- Player
    "client/player/afk.lua",
    "client/player/Movement.lua",
    "client/player/NewPlayer.lua",
    "client/player/Parachute.lua",
    "client/player/Weapon.lua",
    "client/player/playTime.lua",

    -- Init last
    "client/init.lua"
}

server_scripts {
    "server/functions.lua",
    "server/main.lua",
    "server/RemoveVehicles.lua",
    "server/inventory.lua",
    "server/discord-setjob.lua",
    "server/Vehicle.lua",
    "server/StarterPack.lua"
}

server_script "@oxmysql/lib/MySQL.lua"
shared_script '@es_extended/imports.lua'
shared_script '@ox_lib/init.lua'

dependency {
    'mCore',
    'oxmysql',
    'ox_lib',
    "mate-kd",
    "dmf-safezone",
    "discord_rest"
}


escrow_ignore {
    'shared/config.lua',
    '**/*.editable.lua',
}
