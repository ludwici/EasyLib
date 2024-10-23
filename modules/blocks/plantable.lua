local EasyLib = require "easylib:main"

local Plantable = {}

function Plantable:get_drop_table()
    return {}
end

function Plantable:get_base_block_name()
    return "simplefarming:wheat_stage"
end

function Plantable:grow_plant(x, y, z, base_block_name)
    local blockid = block.get(x, y, z)
    local blockName = block.name(blockid)

    if not base_block_name then
        base_block_name = self:get_base_block_name()
    end

    if not base_block_name then
        return
    end

    local states = block.get_states(x, y, z)
    local dec = block.decompose_state(states)

    local age = math.min(dec[3] + 1, self:get_max_age())
    dec[3] = age
    block.set_user_bits(x, y, z, 0, 1, age)
    local newState = block.compose_state(dec)
    -- print(x, y, z, blockName.." modified to "..base_block_name..age, dec[3], states, newState)
    block.place(x, y, z, block.index(base_block_name..age), newState)
end

function Plantable:on_interact(x, y, z, playerid)
    local age = self:get_age(x, y, z)
    if age == self:get_max_age() then
        local ppos = vec3.add({x, y, z}, {0.5, 0.0, 0.5})
        EasyLib:drop_items(ppos, self)
        block.set(x, y, z, block.index("core:air"), 0)
        return true
    end
end

function Plantable:get_age(x, y, z)
    local states = block.get_states(x, y, z)
    local dec = block.decompose_state(states)
    return dec[3]
end

function Plantable:get_max_age()
    return 7
end

return Plantable