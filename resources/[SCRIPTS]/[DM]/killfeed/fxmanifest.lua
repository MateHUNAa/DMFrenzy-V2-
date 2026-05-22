shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'MateHUN'
description 'Killfeed'
version '1.0.5'

shared_script { '@es_extended/imports.lua', 'config.lua' }
client_script 'client.lua'
server_script { 'server.lua' }

escrow_ignore {
	'config.lua',
}
dependency {
	'mate-kd',
	'mCore',
}
ui_page('html/index.html')

files {
	'html/index.html',
	'html/script.js',
	'html/style.css',
	'html/images/*',
	'html/Rajdhani.ttf'
}

