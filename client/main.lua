--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

function handleResourceStart()
    --Start the debug console
    DebugConsole:start()
end

function handleResourceStop()
    -- Stop the debug console
    DebugConsole:stop()
end

-- Add a resource start and a stop handler
addEventHandler("onClientResourceStart", resourceRoot, handleResourceStart)
addEventHandler("onClientResourceStop", resourceRoot, handleResourceStop)
