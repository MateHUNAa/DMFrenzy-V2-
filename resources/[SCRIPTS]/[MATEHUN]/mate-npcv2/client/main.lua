ESX   = exports['es_extended']:getSharedObject()
mCore = exports["mCore"]:getSharedObj()


lang = Loc[Config.lan]

local marker = exports["mate-markers"]

Citizen.CreateThread((function()
     for i, data in pairs(Config.NPCs) do
          if type(data.coords) == "table" then
               for k, pos in pairs(data.coords) do
                    Functions.makePed(data.model, {
                         anim      = nil,
                         collision = data.collision or true,
                         coords    = pos.xyzw,
                         freeze    = true,
                         scenario  = data.scenario or "WORLD_HUMAN_VALET"
                    })

                    local offset = vec3(
                         math.sin(math.rad(-pos.w)),
                         math.cos(math.rad(-pos.w)),
                         0
                    )

                    local _marker = {
                         id             = "rime-npc" .. i.."_"..k,
                         pos            = pos.xyz + offset,
                         help           = data.text,
                         onInteract     = data.action,
                         secondaryColor = { 255, 0, 0, 200 },
                         streamDistance = 8
                    }
                    if data.txdKey and data.txdVal then
                         _marker.txdKey = data.txdKey
                         _marker.txdVal = data.txdVal
                    end

                    marker:AddMarker(_marker)
               end
          else
               Functions.makePed(data.model, {
                    anim      = nil,
                    collision = false,
                    coords    = data.coords,
                    freeze    = true,
                    scenario  = "WORLD_HUMAN_CLIPBOARD"
               })

               local offset = vec3(
                    math.sin(math.rad(-data.coords.w)),
                    math.cos(math.rad(-data.coords.w)),
                    0
               )

               local _marker = {
                    id             = "rime-npc" .. i,
                    pos            = data.coords.xyz + offset,
                    help           = data.text,
                    onInteract     = data.action,
                    secondaryColor = { 255, 0, 0, 200 },
                    streamDistance = 8
               }
               if data.txdKey and data.txdVal then
                    _marker.txdKey = data.txdKey
                    _marker.txdVal = data.txdVal
               end

               marker:AddMarker(_marker)
          end
     end
end))
