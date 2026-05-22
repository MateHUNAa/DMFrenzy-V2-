shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'

lua54 'yes'

name "dmf-safezone"
description "Template used [mCore, ClientOnly]"
author "MateHUN, DMF"
version "1.0.0"

shared_scripts {
	'shared/*.lua'
}

shared_script "@clientloader/shared.lua"
clientloader {
    "client/main.lua",
}



server_scripts {
	'server/*.lua'
}


shared_scripts {
	'@ox_lib/init.lua',
}

shared_script '@es_extended/imports.lua'
server_script "@oxmysql/lib/MySQL.lua"

dependency {
	'mCore',
	'oxmysql',
}


ox_libs {
	'zones'
}
