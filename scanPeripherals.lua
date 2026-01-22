--[[
local function scanPeripherals()
    local list = peripheral.getNames()
    for _,p in ipairs(list) do
        term.clear()
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

]]
local function scanPeripherals()
    term.clear()
    local list = peripheral.getNames()
    for _,p in ipairs(list) do
        local methods = peripheral.getMethods(p)
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


--[[
---------------------
Turbine Methods
---------------------
mbIsConnected()                 returns boolean
getEnergyProducedLastTick()     returns number
getOutputType()                 returns string, "Water" for steam
mbGetMinimumCoordinate()        returns table x y z coords
getInputType()                  returns ""
mbIsPaused()                    returns boolean
getEnergyStats()                returns {energyCapacity = ###, energyProducedLastTick = ###, energyStored = ###, energySystem = "FE"} or other string for FE
mbIsAssembled()                 returns boolean
setVentOverflow()               takes nil, sets vent to overflow
getNumberOfBlades()             returns integer for # of blades
getFluidAmountMax()             returns integer for turbine fluid input capacity in millibuckets
getInductorEngaged()            returns boolean
setVentAll()                    takes nil, sets the vent as before, returns nil
getFluidFlowRate()              returns integer for millibucket of actual fluid consumption
isMethodAvailable()             takes string, returns boolean
getFluidFlowRateMax()
setFluidFlowRateMax()
mbGetMaximumCoordinate()
mbGetMultiblockControllerTypeName()
setInductorEngaged()
getEnergyCapacity()
setVentNone()
getEnergyStored()
getVariant()
getRotorSpeed()
getRotorMass()
getEnergyStoredAsText()
help()                          returns string "not implemented"
getInputAmount()
getFluidFlowRateMaxMax()
mbIsDisassembled()
getOutputAmount()

---------------------
Reactor Methods with Fluid Port
---------------------
mbIsConnected()
getEnergyProductedLastTick
getHotFluidAmountMax
getHotFluidProducedLastTick
mbGetMinimumCoordinate()
getFuelAmount
mbIsPaused
getNumberOfControlRods
getEnergyStats
mbIsAssembled
doEjectWaste
getFuelTemperature
getFuelStats
setControlRodName
setAllControlRodLevels
getHotFluidStats
isMethodAvailable
getCoolantAmount
isActivelyCooled
getControlRodName
getFuelAmountMax
mbGetMaximumCoordinate
getCasingTemperature
getFuelConsumedLastTick
getHotFluidAmount
mbGetMultiblockControllerTypeName
getEnergyCapacity
getHotFluidType
getCoolantType
getEnergyStored
getVariant
getWasteAmount
getEnergyStoredAsText
getCoolantFluidStats
help
setControlRodsLevels
getControlRodLevel
getControlRodsLevels
setActive
getCoolantAmountMax
getFuelReactivity
setControlRodLevel
doEjectFuel
getActive
mbIsDisassembled
getControlRodLocation()

]]
