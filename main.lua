local ExtremeReactor = require("ExtremeReactor")
local ExtremeTurbine = require("ExtremeTurbine")
local display = require("display")

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



while true do
        term.clear()
        term.setCursorPos(1, 1)

        local singleTurbineTarget = 1740
        local reactorTarget = singleTurbineTarget * #devices.turbines
        display.writeNewLine("Turbine Steam Target: ", singleTurbineTarget)
        display.writeNewLine("Reactor Steam Target: ", reactorTarget)
        display.writeNewLine("","")

        local _,cursorY = term.getCursorPos()
        local columnWidths = 10
        display.printRow(
                1, cursorY, columnWidths
                "Reactor #",
                "Ignots/Day",
                "Rod Level",
                "Steam mB/t"
            )
        
        _,cursorY = term.getCursorPos()

        for num, r in ipairs(devices.reactors) do

            r:regulateHotFluid(reactorTarget)

            local ingotsPerDay = math.floor(r:getFuelUsage()*1728)
            local currentRodLevel = r:getControlRodLevel(0)
            local currentSteamProduction = r:getHotFluidProducedLastTick()

            display.printRow(
                1, cursorY, columnWidths,
                num,
                ingotsPerDay,
                currentRodLevel,
                currentSteamProduction
            )

        end

        display.writeNewLine("","")

        for num, t in ipairs(devices.turbines) do
            t:setFluidFlowRateMax(singleTurbineTarget)
            t:setInductorEngaged(true)
            t:setVentOverflow()
            display.writeNewLine("Turbine "..num.." RPM: ",math.floor(t:getRotorSpeed()))
            display.writeNewLine("Turbine "..num.." Charge %: ",math.floor(t:getEnergyStored()/t:getEnergyCapacity()*100))
            display.writeNewLine("Turbine "..num.." kFE/t: ",math.floor(t:getEnergyProducedLastTick()/100)/10)
            display.writeNewLine("","")
        end
    sleep(1)
end
