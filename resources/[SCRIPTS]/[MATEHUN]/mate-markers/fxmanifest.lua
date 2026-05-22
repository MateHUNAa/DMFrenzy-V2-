shared_script '@esx_society/shared_fg-obfuscated.lua'
fx_version "cerulean"
game "gta5"
lua54 'yes'


author 'MateHUN [mhScripts]'
description 'Template used mCore.clientOnly'
version '1.0.0'
github "https://github.com/MateHUNAa/mate-markers"


files {
    "icons/*.png"
}

shared_script "@clientloader/shared.lua"

clientloader {
    "client/main.lua"
}

-- client_scripts {
--     "client/main.lua",
-- }
