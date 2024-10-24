local Properties = {}

Properties.states = 0
Properties.rot = 0
Properties.seg = 0
Properties.property = 0

function Properties:unpack_states(x, y, z, show)
    local states = block.get_states(x, y, z)
    self.states = states
    local dec = block.decompose_state(states)
    self.rot = dec[1]
    self.seg = dec[2]
    self.property = dec[3]
end

function Properties:pack_states()
    self.states = block.compose_state({self.rot, self.seg, self.property})
end

return Properties