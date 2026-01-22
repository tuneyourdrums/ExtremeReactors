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
    r:setRods(100)
end

while true do
        print("Energy:", devices.reactors[1]:getEnergy())
        print("Capacity:", devices.reactors[1]:getCapacity())
        print("Fuel usage:", devices.reactors[1]:getFuelUsage())
        print("RF/t:", devices.reactors[1]:getRF())

        devices.turbines[1]:setFluidFlowRateMax(2000)
        devices.turbines[1]:setInductorEngaged(true)
        devices.turbines[1]:setVentOverflow()

        print("Turbine Capacity:", devices.turbines[1]:getEnergyCapacity())
        print("RF/t:", devices.turbines[1]:getEnergyProducedLastTick())
    sleep(5)
end
