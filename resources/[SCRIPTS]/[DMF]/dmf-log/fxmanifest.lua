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
    "server/main.lua",
}

clientloader {
    "client/functions.lua",
    "client/main.lua"
}


shared_script '@ox_lib/init.lua'
shared_script '@es_extended/imports.lua'

dependency {
    'mCore',
    'ox_lib',
    "ox_inventory"
}


escrow_ignore {
    'shared/config.lua',
    '**/*.editable.lua'
}
