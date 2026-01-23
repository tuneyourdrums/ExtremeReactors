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
            1: column width
            2: column 1 text
            3: column 2 text
            n: column n-1 text
            etc...
    ]]
    
    local columnWidth = args[1]
    local columnBreak = " | "

    for i = 2, #args, 1 do

        local text = tostring(args[i])

        if #text < columnWidth then
            text = text .. string.rep(" ", columnWidth - #text)
        end
        
        write(text)

        if i+1 > #args then break end

        write(columnBreak)
    end

    local _,cursorY = term.getCursorPos()
    term.setCursorPos(1, cursorY+1)
end

function display.printTableStats(...)
    local args = {...}
    


end

return display