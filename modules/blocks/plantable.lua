local EasyLib = require "easylib:main"
local Properties = require "easylib:blocks/properties"
local Plantable = {}

EasyLib:mixin(Plantable, Properties)

function Plantable:get_max_age()
    return 7
end

function Plantable:get_drop_table(x, y, z)
    return {}
end

function Plantable:get_base_block_name()
    return nil
end

function Plantable:grow_plant(x, y, z)
    local blockid = block.get(x, y, z)
    local blockName = block.name(blockid)

    local base_block_name = self:get_base_block_name()

    if not base_block_name then
        return
    end
    self:unpack_states(x, y, z)

    local age = self.property + 1

    if age > self:get_max_age() then
        age = self:get_max_age()
        return false
    end

    local block_index = block.index(base_block_name..age)

    if not block_index then
        return false
    end

    self.property = age

    block.set_user_bits(x, y, z, 0, 1, self.property)
    self:pack_states()

    -- print(x, y, z, blockName.." modified to "..base_block_name..age, self.property, self.states)

    block.place(x, y, z, block_index, self.states)
    return true
end

function Plantable:on_broken(x, y, z, playerid)
    local ppos = vec3.add({x, y, z}, {0.5, 0.0, 0.5})
    EasyLib:drop_items(ppos, self, x, y, z)
    block.set(x, y, z, block.index("core:air"), 0)
end

function Plantable:get_age()
    return self.property
end

return Plantable