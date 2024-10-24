local UsableItem = {}

UsableItem.decrease_count = false

function UsableItem:decrease_item_count(playerid)
    local invID, slotID = player.get_inventory(playerid)
    local itemID, count = inventory.get(invID, slotID)
    count = count - 1
    inventory.set(invID, slotID, itemID, count)
end

function UsableItem:get_conditions_for_use(x, y, z, playerid)
    return nil
end

function UsableItem:use(x, y, z, playerid)
    return true
end

function UsableItem:try_use(x, y, z, playerid)
    local success = self:get_conditions_for_use(x, y, z, playerid)
    if success == false then
        return false
    end

    if self:use(x, y, z, playerid) and self.decrease_count then
        self:decrease_item_count(playerid)
    end

    return true
end

return UsableItem