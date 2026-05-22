fx_version 'adamant'

game 'gta5'

author 'okok#3488'
description 'okokChat'
lua54 'yes'

ui_page 'web/ui.html'

files {
	'web/**.*',
}
dependency { 'oxmysql' }
shared_script { '@es_extended/imports.lua', 'config.lua' }


shared_script "@clientloader/shared.lua"
clientloader {
	'client.lua',
	'ooc.lua',

}

server_scripts {
	'server.lua',
	'commands.lua',
	'@oxmysql/lib/MySQL.lua'
}

export = {
	'chat:addMessage'
}

dependency {
	'mCore',
	'oxmysql',
}
