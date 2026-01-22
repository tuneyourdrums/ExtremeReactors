local ExtremeReactor = require("ExtremeReactor")

local function scanForReactors()
    term.clear()
    term.setCursorPos(1, 1)
    print("Initializing...")

    for _, name in ipairs(peripheral.getNames()) do
        local pType = peripheral.getType(name)
        if pType and string.find(pType, "Reactor") then
            if peripheral.call(name, "mbIsAssembled") == true then
                print("ExtremeReactor found!")
                return ExtremeReactor.new(name)
            end
        end
    end

    print("Reactor not found.")
    return nil
end

local reactor = scanForReactors()

if not reactor then
    print("Cannot continue without reactor.")
    return
end

reactor:setRods(100)
print("Energy:", reactor:getEnergy())
print("Capacity:", reactor:getCapacity())
print("Fuel usage:", reactor:getFuelUsage())
print("RF/t:", reactor:getRF())