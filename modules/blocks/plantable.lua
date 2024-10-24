local EasyLib = require "easylib:main"

local Plantable = {}

Plantable.states = {}

function Plantable:get_max_age()
    return 7
end

function Plantable:get_drop_table(x, y, z)
    return {}
end

function Plantable:get_base_block_name()
    return nil
end

function Plantable:update_states(x, y, z)
    self.states = block.get_states(x, y, z)
end

function Plantable:grow_plant(x, y, z)
    local blockid = block.get(x, y, z)
    local blockName = block.name(blockid)

    local base_block_name = self:get_base_block_name()

    if not base_block_name then
        return
    end

    local states = block.get_states(x, y, z)
    local dec = block.decompose_state(states)

    local age = dec[3] + 1
    if age > self:get_max_age() then
        age = self:get_max_age()
        return false
    end

    local block_index = block.index(base_block_name..age)

    if not block_index then
        return false
    end

    dec[3] = age
    block.set_user_bits(x, y, z, 0, 1, age)
    local newState = block.compose_state(dec)
    -- print(x, y, z, blockName.." modified to "..base_block_name..age, dec[3], states, newState)

    block.place(x, y, z, block_index, newState)
    return true
end

function Plantable:on_broken(x, y, z, playerid)
    local ppos = vec3.add({x, y, z}, {0.5, 0.0, 0.5})
    EasyLib:drop_items(ppos, self, x, y, z)
    block.set(x, y, z, block.index("core:air"), 0)
end

function Plantable:get_age()
    local dec = block.decompose_state(self.states)
    return dec[3]
end

return Plantable