Functions = {
    getFieldFromData = function(data, field)
        local fieldValue = nil

        local fieldIndex = string.find(data, '"' .. field .. '":')
        if fieldIndex then
            local remainingString = string.sub(data, fieldIndex + string.len(field) + 3) -- Adding 3 to account for the length of the field name and '":'

            local commaIndex = string.find(remainingString, ',')
            local endIndex = string.find(remainingString, '}')

            if commaIndex and commaIndex < endIndex then
                fieldValue = tonumber(string.sub(remainingString, 1, commaIndex - 1))
            else
                fieldValue = tonumber(string.sub(remainingString, 1, endIndex - 1))
            end
        end

        return fieldValue
    end
}
