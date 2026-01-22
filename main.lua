local ExtremeReactor = require("ExtremeReactor")

local ExtremeTurbine = require("ExtremeTurbine")

local function scanForReactors()
    term.clear()
    term.setCursorPos(1, 1)
    print("Initializing...")

    local result = {
        reactors = {},
        turbines = {}
    }

    for _, name in ipairs(peripheral.getNames()) do
        local pType = peripheral.getType(name)

        if pType == "BigReactors-Reactor" then
            local ok, assembled = pcall(peripheral.call, name, "mbIsAssembled")
            if ok and assembled then
                print("ExtremeReactor found:", name)
                table.insert(result.reactors, ExtremeReactor.new(name))
            end

        elseif pType == "BigReactors-Turbine" then
            local ok, assembled = pcall(peripheral.call, name, "mbIsAssembled")
            if ok and assembled then
                print("ExtremeTurbine found:", name)
                table.insert(result.turbines, ExtremeTurbine.new(name))
            end
        end
    end

    return result
end


local devices = scanForReactors()

if #devices.reactors == 0 or #devices.turbines == 0 then
    print("No reactors or turbines available.")
    return
end


for _, t in ipairs(devices.turbines) do
    t:setActive(true)
end

for _, r in ipairs(devices.reactors) do
    r:setActive(true)
    r:setRods(50)
end

local function writeNewLine(key, value)
    write(key)
    local _,y = term.getCursorPos()
    term.setCursorPos(20,y)
    write(value)
    term.setCursorPos(1,y+1)
end

while true do
        term.clear()
        term.setCursorPos(1, 1)

        local singleTurbineTarget = 1740
        local reactorTarget = singleTurbineTarget * #devices.turbines
        writeNewLine("Turbine Steam Target: ", singleTurbineTarget)
        writeNewLine("Reactor Steam Target: ", reactorTarget)

        for num, r in ipairs(devices.reactors) do
            r:regulateHotFluid(reactorTarget)

            writeNewLine("Reactor "..num.." Ignots/Day: ",math.floor(r:getFuelUsage()*1728))
            writeNewLine("Reactor "..num.." Rod Level: ", r:getControlRodLevel(0))
            writeNewLine("Reactor "..num.." Rod Level: ", r:getHotFluidProducedLastTick())

        end
        
        for num, t in ipairs(devices.turbines) do
            t:setFluidFlowRateMax(singleTurbineTarget)
            t:setInductorEngaged(true)
            t:setVentOverflow()
            writeNewLine("Turbine "..num.." Charge %: ",math.floor(t:getEnergyStored()/t:getEnergyCapacity()*100))
            writeNewLine("Turbine "..num.." kFE/t: ",math.floor(t:getEnergyProducedLastTick()/100)/10)
        end
    sleep(1)
end
