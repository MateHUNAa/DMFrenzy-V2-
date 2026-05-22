RegisterNetEvent("mate-coords:sendBulk", function(name, a, b, c, d, e)
        local source = source
        local a = exports["mate-admin"]:isAdmin(source)
        if not a then return end

        local message = string.format([[

```fix
--------------------------------[ %s ]--------------------------------
```
```css
%s,
```
```css
%s,
```
```css
%s,
```
```css
%s,
```
```css
%s,
```
```fix
----------------------------------------------------------------------
```
]]
        , name, a, b, c, d, e)
        exports["mCore"]:sendMessage(Config.Webhook, "MateHUN Coords", message)
end)



RegisterNetEvent('mate-coords:SendTableCoords', function(d)
        local source = source
        local a = exports["mate-admin"]:isAdmin(source)
        if not a then return end
        local message = ""

        for _, v in pairs(d) do
                message = ("%svec4(%s,%s,%s,%s),\n"):format(message, round(v.x, 3), round(v.y, 3), round(v.z, 3), v.w)
        end

        exports["mCore"]:sendMessage(Config.Webhook, "MateHUN Coords", ([[
```css
%s
```
        ]]):format(message))
end)

function round(num, numDecimalPlaces)
        local mult = 5 ^ (numDecimalPlaces or 0)
        return math.floor(num * mult + 0.5) / mult
end
