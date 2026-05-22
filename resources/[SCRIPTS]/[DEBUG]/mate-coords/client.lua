ESX = exports["es_extended"]:getSharedObject()

RegisterCommand('gc', function()
  local x, y, z = table.unpack(GetEntityCoords(GetPlayerPed(-1), true))
  local heading = GetEntityHeading(PlayerPedId())

  x = round(x, 3)
  y = round(y, 3)
  z = round(z - 1, 3)
  local h = round(heading, 4)

  local codeA = string.format("{x = %s, y = %s, z = %s, heading = %s}", x, y, z, h)
  local codeB = string.format("['x'] = %s, ['y'] = %s, ['z'] = %s", x, y, z)
  local codeC = string.format("%s,%s,%s,%s", x, y, z, h)

  local codeD = string.format("vector3(%s,%s,%s)", x, y, z)
  local codeE = string.format("vector4(%s,%s,%s,%s)", x, y, z, h)

  ESX.UI.Menu.Open(
    'dialog', GetCurrentResourceName(), 'codemenu',
    {
      title = "MateHUN Coords !"
    },
    function(data, menu)
      local name = data.value

      TriggerServerEvent('mate-coords:sendBulk', name, codeA, codeB, codeC, codeD, codeE)
      menu.close()
    end,
    function(data, menu)
      menu.close()
    end)
end, false)

local table = {}
RegisterCommand("tgc", (function(src, args, raw)
  local mypos = GetEntityCoords(PlayerPedId())
  local myHead = GetEntityHeading(PlayerPedId())

  local x = ESX.Math.Round(mypos.x, 3)
  local y = ESX.Math.Round(mypos.y, 3)
  local z = ESX.Math.Round(mypos.z - 1, 3)
  local h = myHead

  local vec = vec4(x, y, z, h)


  table[#table + 1] = vec
end))

RegisterCommand("gcc", (function(src, args, raw)
  if not table and next(table) == nil then return end
  TriggerServerEvent('mate-coords:SendTableCoords', table)

  table = {}
end))

function round(num, numDecimalPlaces)
  local mult = 5 ^ (numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
