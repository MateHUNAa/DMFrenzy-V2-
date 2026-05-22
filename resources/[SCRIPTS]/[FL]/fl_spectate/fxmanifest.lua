shared_script '@esx_society/shared_fg-obfuscated.lua'
shared_script '@FIREAC/xero_safe_loader.lua'
shared_script '@FIREAC/xero_module_loader.lua'
shared_script '@ac/shared_fg-obfuscated.lua'
fx_version("cerulean")
game("gta5")
author("Csoki")

shared_script("@es_extended/imports.lua")
shared_script("shared.lua")

client_script("client.lua")
server_script("server.lua")

dependency {
	'mCore',
}

files({
	"ui/*",
})

ui_page("ui/index.html")
