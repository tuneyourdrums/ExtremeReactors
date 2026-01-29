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

function ExtremeReactor:getHotFluidAmountMax()
    return self.peripheral.getHotFluidAmountMax()
end

function ExtremeReactor:getHotFluidAmount()
    return self.peripheral.getHotFluidAmount()
end

function ExtremeReactor:regulateHotFluidCapacity(target)
    -- Units in mB or 0.00 ratio / percent
    local deadband = 0.05   -- % of full, so 5%
    local tankCapacity = self:getHotFluidAmountMax()
    local tankFillCurrent = self:getHotFluidAmount()
    local tankFillPercent = tankFillCurrent/tankCapacity
    
    local error = target - tankFillPercent

    if math.abs(error) <= deadband then return true end

    local rods = self:getControlRodLevel(0)
    
    local step = math.abs(error) * 5

    if step < 0 then step = 0 end
    if step > 5 then step = 5 end

    if error > 0 then
        rods = rods - step
    else
        rods = rods + step
    end

    if rods < 0 then rods = 0 end
    if rods > 100 then rods = 100 end

    if rods ~= self:getControlRodLevel(0) then
        self.peripheral.setAllControlRodLevels(rods)
    end

end

function ExtremeReactor:regulateHotFluid(target)
    local deadband = 50

    local produced = self:getHotFluidProducedLastTick()
    local error = target - produced

    local rods = self:getControlRodLevel(0)

    if math.abs(error) <= deadband then
        return {
            target = target,
            produced = produced,
            rods = rods,
            step = 0
        }
    end

    local step = math.floor(math.abs(error) / 200)
    if step < 1 then step = 1 end
    if step > 10 then step = 10 end

    if error > 0 then
        rods = rods - step
    else
        rods = rods + step
    end

    if rods < 0 then rods = 0 end
    if rods > 100 then rods = 100 end

    if rods ~= self:getControlRodLevel(0) then
        self.peripheral.setAllControlRodLevels(rods)
    end

    return {
        target = target,
        produced = produced,
        rods = rods,
        step = step
    }
end


return ExtremeReactor