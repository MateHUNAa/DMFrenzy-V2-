local currentRules = {}
RegisterNetEvent('mate-dimManager->Update', function(data)
     currentRules = data.rules
end)


function _ReloadPedWeapon()
     local weapon = GetSelectedPedWeapon(cache.ped)

     if weapon ~= GetHashKey("WEAPON_UNARMED") then
          local maxAmmo     = GetMaxAmmoInClip(cache.ped, weapon) or 0
          local currentAmmo = GetAmmoInPedWeapon(cache.ped, weapon) or 0

          if currentAmmo < maxAmmo then
               SetAmmoInClip(cache.ped, weapon, maxAmmo)

               local loadedRounds = maxAmmo - currentAmmo

               if currentRules["WeaponDurability"] then
                    TriggerServerEvent("dmf-core->CWPCAMODUR", loadedRounds)
               end
          end
     end
end

function _NoRecoil()
     if IsPedArmed(PlayerPedId(), 6) then
          SetWeaponRecoilShakeAmplitude(GetSelectedPedWeapon(PlayerPedId()), 0)
          SetPedAccuracy(PlayerPedId(), 100)
     end
end
