local function scanPeripherals()
    local list = peripheral.getNames()
    for _,p in ipairs(list) do
        print(p)
        local methods = peripheral.getMethods(p)
        local counter = 0
        for _,m in ipairs(methods) do
            print(m)
            counter = counter + 1
            if counter >= 15 then
                sleep(15)
                counter = 0
                term.clear()
                print(p)
            end
        end
    end
end

return scanPeripherals()