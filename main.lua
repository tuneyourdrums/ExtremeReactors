local ExtremeReactor = require("ExtremeReactor")

local function scanForReactors()
    term.clear()
    term.setCursorPos(1, 1)
    write("Initializing...")
    term.setCursorPos(1, 2)

    for _, name in ipairs(peripheral.getNames()) do
        if string.find(peripheral.getType(name), "ExtremeReactor") then
            for _, method in ipairs(peripheral.getMethods(name)) do
                if method == "mbIsAssembled" then
                    if peripheral.call(name, "mbIsAssembled") == true then
                        write("ExtremeReactor found!")
                        return ExtremeReactor.new(name)
                    end
                end
            end
        end
    end

    write("Reactor not found.")
    return nil
end

local reactor = scanForReactors()

reactor:setRods(100)
print(reactor:getEnergy())
print(reactor:getCapacity())
print(reactor:getFuelUsage())
print(reactor:getRF())