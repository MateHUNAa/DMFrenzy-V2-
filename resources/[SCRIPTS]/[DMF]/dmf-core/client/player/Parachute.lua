local Parachute = {}

function _Parachute()
     local isFalling = IsPedFalling(cache.ped)
     local isInAir = not IsPedOnFoot(cache.ped)

     if (isFalling or isInAir) and not HasPedGotWeapon(cache.ped, GetHashKey("GADGET_PARACHUTE"), false) then
          GiveWeaponToPed(cache.ped, GetHashKey("GADGET_PARACHUTE"), 1, false, true)
     elseif not (isFalling or isInAir) and HasPedGotWeapon(cache.ped, GetHashKey("GADGET_PARACHUTE"), false) then
          RemoveWeaponFromPed(cache.ped, GetHashKey("GADGET_PARACHUTE"))
     end
end

return Parachute
