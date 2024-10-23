local EasyLib = {}

local function drop_item(ppos, name, count)
    if not count then
        count = 1
    end
    local drop = entities.spawn("base:drop", ppos, {base__drop={
        id=item.index(name),
        count=count
    }})
    local dir = player.get_dir()
    local thrown_force = vec3.mul(dir, 1.5)
    local vel = vec3.add(thrown_force, {0, 8, 0})
    drop.rigidbody:set_vel(vel)
end

function EasyLib:mixin(object, ...)
    local parents = {...}

    for _, mixin in ipairs(parents) do
        for key, value in pairs(mixin) do
            object[key] = value
        end
    end

    return object
end

function EasyLib:drop_items(ppos, block)
    local dropTable = block:get_drop_table()
    if not dropTable then
        return
    end

    for _, drop in ipairs(dropTable) do
        drop_item(ppos, drop.name, drop.count)
    end
end

function EasyLib:has_block_above(x, y, z)
    return block.get(x, y + 1, z) ~= 0
end

function EasyLib:has_block_below(x, y, z)
    return block.get(x, y - 1, z) ~= 0
end

return EasyLib