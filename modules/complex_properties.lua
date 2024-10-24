local complex_property = {}
complex_property.__index = complex_property

function complex_property:new(value)
    local instance = setmetatable({}, self)
    instance.value = value or 0
    return instance
end

function complex_property:set_state(prop)
    self.value = bit.bor(self.value, prop)
end

function complex_property:get_state(prop)
    return bit.band(self.value, prop) > 0
end

function complex_property:set_value(prop, value)
    self.value = bit.band(self.value, bit.bnot(bit.lshift(prop, prop)))
    self:set_state(bit.lshift(value, prop))
end

function complex_property:get_value(prop)
    return bit.band(bit.rshift(self.value, prop), prop)
end

return complex_property