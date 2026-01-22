local ExtremeReactor = {}
ExtremeReactor.__index = ExtremeReactor

function ExtremeReactor.new(name)
    local wrapped = peripheral.wrap(name)
    assert(wrapped, "Failed to wrap peripheral: " .. tostring(name))

    local self = {
        name = name,
        peripheral = wrapped,
        capacity = wrapped.getEnergyCapacity()
    }

    return setmetatable(self, ExtremeReactor)
end

function ExtremeReactor:setActive(state)
    return self.peripheral.setActive(state)
end

function ExtremeReactor:setRods(level)
    return self.peripheral.setAllControlRodLevels(level)
end

function ExtremeReactor:getEnergy()
    return self.peripheral.getEnergyStored()
end

function ExtremeReactor:getCapacity()
    return self.capacity
end

function ExtremeReactor:getFuelUsage()
    return self.peripheral.getFuelConsumedLastTick()
end

function ExtremeReactor:getRF()
    return self.peripheral.getEnergyProducedLastTick()
end

return ExtremeReactor