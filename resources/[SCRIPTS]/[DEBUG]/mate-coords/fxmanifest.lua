shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version 'cerulean'

game 'gta5'
author 'MateHUN'
lua54 'yes'


description 'Show Cords and link with discord.'
shared_script {
    'config.lua',
    '@es_extended/imports.lua'
}

dependency {
    'mCore',
}


client_script {
    'client.lua',
    'c_visibleCoords.lua',
}

server_script {
    'server.lua'
}


escrow_ignore 'config.lua'