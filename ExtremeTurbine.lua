local ExtremeTurbine = {}
ExtremeTurbine.__index = ExtremeTurbine

function ExtremeTurbine.new(name)
    local wrapped = peripheral.wrap(name)
    assert(wrapped, "Failed to wrap peripheral: " .. tostring(name))

    local self = setmetatable({}, ExtremeTurbine)

    self.name = name
    self.peripheral = wrapped

    self.capacity = wrapped.getEnergyCapacity()

    return self
end

function ExtremeTurbine:setActive(state)
    return self.peripheral.setActive(state)
end


function ExtremeTurbine:setFluidFlowRateMax(rate)
    return self.peripheral.setFluidFlowRateMax(rate)
end

function ExtremeTurbine:setInductorEngaged(state)
    return self.peripheral.setInductorEngaged(state)
end

function ExtremeTurbine:setVentOverflow()
    return self.peripheral.setVentOverflow()
end

function ExtremeTurbine:getEnergyCapacity()
    return self.capacity
end

function ExtremeTurbine:getEnergyProducedLastTick()
    return self.peripheral.getEnergyProducedLastTick()
end

return ExtremeTurbine
