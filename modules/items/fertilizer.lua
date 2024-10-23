local EasyLib = require "easylib:main"
local UsableItem = require "easylib:items/usable_item"

local Fertilizer = {}
EasyLib:mixin(Fertilizer, UsableItem)

Fertilizer.decrease_count = true

local function starts_with(str, start)
    return string.sub(str, 1, string.len(start)) == start
end

function Fertilizer:get_plant_family()
    return {}
end

function Fertilizer:apply(x, y, z, playerid)
    local blockid = block.get(x, y, z)
    local blockName = block.name(blockid)

    local plantFamily = self:get_plant_family()
    if next(plantFamily) then
        for _, value in ipairs(plantFamily) do
            if starts_with(blockName, value) then
                self.blockName = value
                return true
            end
        end
    end

    return false
end

return Fertilizer