local function writeNewLine(key, value)
    write(key)
    local _,y = term.getCursorPos()
    term.setCursorPos(25,y)
    write(value)
    term.setCursorPos(1,y+1)
end

local function printRow(...)
    local args = {...}

    --[[ args:
            1: cursor starting X
            2: cursor sarting Y
            3: column 1 text
            4: column 1 width
            5: column 2 text
            6: column 2 width
            etc...
    ]]
    
    local cursorX = args[1]
    local cursorY = args[2]
    local columnBreak = " | "

    for i = 3, #args-2, 2 do
        term.setCursorPos(cursorX, cursorY)
        write(args[i].." | ")
        cursorX = cursorX + args[i+1] + #columnBreak
    end

    term.setCursorPos(1, cursorY+1)
end

local function printTableStats(...)
    local args = {...}
    


end