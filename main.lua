local ExtremeReactor = require("ExtremeReactor")

local ExtremeReactor = require("ExtremeReactor")

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

        if pType and string.find(pType, "BigReactor-Reactor") then
            if peripheral.call(name, "mbIsAssembled") == true then
                print("ExtremeReactor found:", name)
                table.insert(result.reactors, ExtremeReactor.new(name))
            end
        elseif pType and string.find(pType, "BigReactor-Turbine") then
            if peripheral.call(name, "mbIsAssembled") == true then
                print("ExtremeTurbine found:", name)
                table.insert(result.reactors, ExtremeReactor.new(name))
            end
        end
    end

    if #result.reactors == 0 then
        print("No reactors found.")
    end
    if #result.turbines == 0 then
        print("No turbines found.")
    end

    return result
end


local devices = scanForReactors()

if not devices then
    print("Cannot continue without reactor.")
    return
end

devices.reactors[1]:setRods(100)
print("Energy:", devices.reactors[1]:getEnergy())
print("Capacity:", devices.reactors[1]:getCapacity())
print("Fuel usage:", devices.reactors[1]:getFuelUsage())
print("RF/t:", devices.reactors[1]:getRF())