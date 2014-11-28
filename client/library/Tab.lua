--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

class "Tab"

function Tab:create(name, options)
    -- Verify the parameter 'name'
    if (type(name) ~= "string" or #name == 0) then
        return "parameter type mismatch [param: name, type: string]"
    end

    -- Verify the optional parameter 'options'
    if (type(options) ~= "table") then
        options = { }
    end

    return {
        name = name,
        options = options
    }
end

function Tab:construct()
    
end
