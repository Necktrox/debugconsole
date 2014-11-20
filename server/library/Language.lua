--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "Language"

function Language:getPackage(code)
    -- TODO: implement different languages
    return toJSON({settings = "Settings", newtab = "Open a new tab"})
end
