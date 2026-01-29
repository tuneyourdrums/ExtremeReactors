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
    r:setRods(100)
end



while true do
        term.clear()
        term.setCursorPos(1, 1)

        local singleTurbineTarget = 1740
        local reactorTarget = (singleTurbineTarget+ 50) * #devices.turbines
        display.writeNewLine("Turbine Steam Target: ", singleTurbineTarget)
        display.writeNewLine("Reactor Steam Target: ", reactorTarget)
        display.writeNewLine("","")

        local columnWidths = 10

        display.printRow(
                columnWidths, colors.lightGray,
                "Reactor #",
                "Ignots/Day",
                "Rod Level",
                "Steam mB/t"
            )
        

        for num, r in ipairs(devices.reactors) do

            r:regulateHotFluid(reactorTarget, #devices.turbines)

            --r:regulateHotFluidCapacity(0.5)

            local ingotsPerDay = math.floor(r:getFuelUsage()*1728)
            local currentRodLevel = r:getControlRodLevel(0)
            local currentSteamProduction = r:getHotFluidProducedLastTick()

            display.printRow(
                columnWidths, colors.white,
                num,
                ingotsPerDay,
                currentRodLevel,
                currentSteamProduction
            )

        end

        display.writeNewLine("","")

        display.printRow(
                columnWidths, colors.lightGray,
                "Turbine #",
                "RPM",
                "Charge",
                "kFE/t"
        )


        for num, t in ipairs(devices.turbines) do
            t:setFluidFlowRateMax(singleTurbineTarget)
            t:setInductorEngaged(true)
            t:setVentOverflow()

            local currentRPM = math.floor(t:getRotorSpeed())
            local currentCharge = math.floor(t:getEnergyStored()/t:getEnergyCapacity()*100)
            local currentKFEperTick = math.floor(t:getEnergyProducedLastTick()/100)/10

            display.printRow(
                columnWidths, colors.white,
                num,
                currentRPM,
                currentCharge,
                currentKFEperTick
            )
        end
    sleep(1)
end
