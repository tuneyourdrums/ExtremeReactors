local display = {}

function display.writeNewLine(key, value)
    write(key)
    local _,y = term.getCursorPos()
    term.setCursorPos(25,y)
    write(value)
    term.setCursorPos(1,y+1)
end

function display.printRow(...)
    local args = {...}

    --[[ args:
            1: cursor starting X
            2: cursor sarting Y
            3: column width
            4: column 1 text
            5: column 2 text
            6: column 3 text
            etc...
    ]]
    
    local cursorX = args[1]
    local cursorY = args[2]
    local columnWidth = args[3]
    local columnBreak = " | "

    term.setCursorPos(cursorX, cursorY)

    for i = 4, #args-3, 1 do

        local text = tostring(args[i])

        if #text < columnWidth then
            text = text .. string.rep(" ", columnWidth - #text)
        end
        
        write(text)
        write(columnBreak)
    end

    term.setCursorPos(1, cursorY+1)
end

function display.printTableStats(...)
    local args = {...}
    


end

return display