fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'MateHUN'
version "1.2.0"

description "Report system ! "

shared_scripts {
    "@es_extended/imports.lua",
    "@es_extended/locale.lua",
    "config.lua",
}

dependency {
    'mCore',
    'oxmysql',
    "mate-admin"
}

server_scripts {
    "server/functions.lua",
    "server/main.lua",
}

shared_script "@clientloader/shared.lua"
clientloader {
    "client/functions.lua",
    "client/main.lua",
}

-- client_scripts {
--     "client/functions.lua",
--     "client/main.lua",
-- }


files {
    "html/index.html",
    "html/assets/*.js",
    "html/assets/*.css"
}


ui_page "html/index.html"



escrow_ignore { 
    "config.lua",
}