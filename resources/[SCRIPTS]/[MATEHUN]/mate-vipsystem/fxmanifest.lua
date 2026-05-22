shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'

dependency { "mCore", "oxmysql", "ox_lib" }

server_scripts {
    "server/main.lua",
    "@oxmysql/lib/MySQL.lua",
    "config.lua"
}

shared_script {
    "shared.lua"
}
escrow_ignore {
    'config.lua'
}

shared_script '@ox_lib/init.lua'
shared_script '@es_extended/imports.lua'
