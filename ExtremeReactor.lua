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

function ExtremeReactor:getHotFluidProducedLastTick()
    return self.peripheral.getHotFluidProducedLastTick()
end

function ExtremeReactor:getControlRodLevel(num)
    return self.peripheral.getControlRodLevel(num)
end

function ExtremeReactor:regulateHotFluid(target)
    local deadband = 50

    local produced = self:getHotFluidProducedLastTick()
    local error = target - produced

    local rods = self:getControlRodLevel(0)

    -- deadband: no change
    if math.abs(error) <= deadband then
        return {
            target = target,
            produced = produced,
            rods = rods,
            step = 0
        }
    end

    -- dynamic step size based on error magnitude
    local step = math.floor(math.abs(error) / 200)
    if step < 1 then step = 1 end
    if step > 10 then step = 10 end

    -- inverted control:
    -- need more fluid -> LOWER rods
    -- need less fluid -> RAISE rods
    if error > 0 then
        rods = rods - step
    else
        rods = rods + step
    end

    -- clamp safely
    if rods < 0 then rods = 0 end
    if rods > 100 then rods = 100 end

    -- apply only when outside deadband
    self.peripheral.setAllControlRodLevels(rods)

    return {
        target = target,
        produced = produced,
        rods = rods,
        step = step
    }
end


return ExtremeReactor