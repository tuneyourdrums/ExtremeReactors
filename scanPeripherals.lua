local function scanPeripherals()
    local list = peripheral.getNames()
    for _,p in ipairs(list) do
        print(p)
    end
end

return scanPeripherals()