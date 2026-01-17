local reactor
local producedEnergy
local storedEnergy
local capacity
local rodLevel
local fuelUsage


function initializeReactor()
	term.clear()    
	term.setCursorPos(1, 1)	
	write("Initializing...")
    term.setCursorPos(1, 2)
    for i,name in ipairs(peripheral.getNames()) do
        if string.find(peripheral.getType(name), 'Reactor') ~= nil then
            for j,method in ipairs(peripheral.getMethods(name)) do
				if string.find(method, 'mbIsAssembled') ~= nil then
                    if peripheral.call(name, 'mbIsAssembled') ~= nil then
                		write('ExtremeReactor found!')
                		return {'Extreme',peripheral.wrap(name)}
                    end
                elseif string.find(method, 'battery') ~= nil then    
            		if peripheral.call(name, 'connected') ~= nil then
                    	write('BiggerReactor found!')
                		return {'Bigger',peripheral.wrap(name)}
                    end
				end
        	end
        end
	end
    write('Reactor not found.')
    return {nil,nil}
end

function setRods(reactor, level)
    if reactor[1] == 'Extreme' then
        return reactor[2].setAllControlRodLevels(level)
    elseif reactor[1] == 'Bigger' then
    	return reactor[2].setAllControlRodLevels(level)
    end
end

function getEnergy(reactor)
    if reactor[1] == 'Extreme' then
        return reactor[2].getEnergyStored()
    elseif reactor[1] == 'Bigger' then
    	return reactor[2].battery().stored()
    end
end

function getCapacity(reactor)
    if reactor[1] == 'Extreme' then
        return reactor[2].getEnergyCapacity()
    elseif reactor[1] == 'Bigger' then
    	return reactor[2].battery().capacity()
    end
end

function getFuelUsage(reactor)
    if reactor[1] == 'Extreme' then
        return reactor[2].getFuelConsumedLastTick()
    elseif reactor[1] == 'Bigger' then
    	return reactor[2].fuelTank().burnedLastTick()
    end
end

function getRF(reactor)
    if reactor[1] == 'Extreme' then
        return reactor[2].getEnergyProducedLastTick()
    elseif reactor[1] == 'Bigger' then
    	return reactor[2].battery().producedLastTick()
    end
end

local reactor = initializeReactor()

setRods(reactor, 100)
capacity = getCapacity(reactor)

sleep(2)

local rodLevel

while(true) do

    storedEnergy = getEnergy(reactor)
    
    fuelUsageRaw = getFuelUsage(reactor)
    producedEnergy = getRF(reactor)
    
    rodLevel = (storedEnergy/capacity) * 100
	if rodLevel > 99.95 then rodLevel=99.95 end
	rodLevel = math.floor( 100 * (rodLevel) ) / 100
	fuelUsage = math.floor( 100 * (fuelUsageRaw / 1000 * 20 * 60 * 60 * 24) ) / 100

	setRods(reactor, rodLevel)
    
	term.clear()
    term.setCursorPos(1, 1)
    write("Rod Level:     " .. rodLevel)
    term.setCursorPos(1, 3)
    write("RF Out:        " .. producedEnergy)
	term.setCursorPos(1, 5)
    write("Ingots/Day:    " .. fuelUsage)

    sleep(0.5)
end