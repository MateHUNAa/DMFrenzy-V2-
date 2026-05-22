Config = {
     lan = "en",
     PedRenderDistance = 80.0,
     target = true,
     eventPrefix = "mhScripts"
}
Config.MHAdminSystem = GetResourceState("mate-admin") == "started"
Config.ApprovedLicenses = {
     "license:123",
     "fivem:123",
     "discord:123",
     "live:123",
     "steam:123",
     "xbl:123"
}
Config.WeaponPrices = {
     ["WEAPON_SFXD"]          = 3,
     ["WEAPON_DMFCOMBAT"]     = 3,
     ["WEAPON_fnx45"]         = 4,
     ["WEAPON_GC18"]          = 6,
     ["WEAPON_machinepistol"] = 7,
     ["WEAPON_HEAVYPISTOL"]   = 3,
     ["WEAPON_PISTOL_MK2"]    = 3,
}

Config.WeaponBlackList = {
     ["WEAPON_VIP"]     = true,
     ["WEAPON_GREENAP"] = true,
     ["WEAPON_RICKAP"]  = true,
     ["WEAPON_PORNAP"]  = true,
     ["weapon_TEST"]    = true,
     ["WEAPON_TOXICAP"] = true,
}

Config.NPCs = {
     ["ShopNPC"] = {
          coords    = {
               vec4(219.5811, -809.9655, 29.6757, 9.5667), --[[ publik ]]
          },
          model     = `mp_m_shopkeep_01`,
          text      = "Bolt",
          action    = (function()
               exports.ox_inventory:openInventory("shop", { type = "General" })
          end),
          txdKey    = "markers-txd",
          txdVal    = "shop",
          scenario  = "WORLD_HUMAN_DRINKING",
          collision = true
     },
     ["ClothNPC"] = {
          coords    = {
               vec4(240.6562, -810.7145, 29.2411, 70.3113), --[[ publik ]]
          },
          model     = `s_f_y_hooker_03`,
          text      = "Cloth Store",
          action    = (function()
               -- exports.ox_inventory:openInventory('stash', { id = 'tarolo' })
               TriggerEvent('illenium-appearance:client:openClothingShopMenu', 0)
          end),
          txdKey    = "markers-txd",
          txdVal    = "cloth",
          collision = true,
          scenario  = "WORLD_HUMAN_PARTYING"
     },
     ["LeaveNPC"] = {
          coords    = {
               vec4(228.5088, -812.9783, 29.4470, 337.3606), --[[ publik ]]
          },
          model     = `mp_m_avongoon`,
          text      = "Leave",
          action    = (function()
               ExecuteCommand("leave")
          end),
          txdKey    = "markers-txd",
          txdVal    = "exit",
          scenario  = "WORLD_HUMAN_GOLF_PLAYER",
          collision = true
     },

     ["VehicleShop"] = {
          coords    = {
               vector4(215.8485, -807.9763, 29.7645, 300.2079), --[[ publik ]]
          },
          model     = `mp_m_execpa_01`,
          text      = "VehicleShop",
          action    = (function()
               exports.ox_inventory:openInventory("shop", { type = "Vehicle" })
          end),
          txdKey    = "markers-txd",
          txdVal    = "vehicle_shop",
          scenario  = "WORLD_HUMAN_SMOKING_CLUBHOUSE",
          collision = true
     },
     ["PPShop"] = {
          coords    = {
               vector4(216.9786, -810.2212, 29.7039, 326.5443), --[[ publik ]]
          },
          model     = `u_m_m_aldinapoli`,
          text      = "PP SHOP",
          action    = (function()
               exports.ox_inventory:openInventory("shop", { type = "Ppshop" })
          end),
          txdKey    = "markers-txd",
          txdVal    = "vip_shop",
          scenario  = "WORLD_HUMAN_JOG_STANDING",
          collision = true
     },
     ["SalerNPC"] = {
          coords    = {
               vector4(222.3311, -811.4444, 29.5925, 346.3757), --[[ FO PUB ]]
          },
          model     = `mp_m_bogdangoon`,
          text      = "VehicleShop",
          action    = (function()
               local Weapons  = {}
               local Elements = {}

               for item, data in pairs(exports.ox_inventory:Items()) do
                    if data.weapon then
                         table.insert(Weapons, data)
                    end
               end

               for item, data in pairs(exports.ox_inventory:GetPlayerItems()) do
                    for i, v in ipairs(Weapons) do
                         local blacklisted = false

                         for b, _ in pairs(Config.WeaponBlackList) do
                              if b == v.model then
                                   blacklisted = true
                                   break
                              end
                         end


                         if not blacklisted then
                              if data.metadata and data.metadata.durability then
                                   if data.metadata.durability >= 0 then
                                        print(("%s has been blacklisted"):format(data.name))
                                        blacklisted = true
                                   end
                              end
                         end

                         if not blacklisted and data.name == v.model then
                              Elements[#Elements + 1] = {
                                   title       = v.name:sub(8),
                                   description = v.model,
                                   icon        = "fa-gun",
                                   onSelect    = (function()
                                        local success = lib.callback.await("dmf->SellWeapon", false, v.name,
                                             Config.WeaponPrices[name],
                                             GetCurrentResourceName())
                                   end),
                                   image       = ("nui://ox_inventory/web/images/%s.png"):format(v.name)
                              }
                         end
                    end
               end


               lib.registerContext({
                    id = 'sellernpc',
                    title = 'DMF Sell',
                    options = Elements
               })

               lib.showContext("sellernpc")
          end),
          txdKey    = "markers-txd",
          txdVal    = "sell",
          scenario  = "WORLD_HUMAN_DRUG_DEALER",
          collision = true
     },

}

Loc = {}
