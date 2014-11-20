--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "Language"

function Language:apply(package)
    -- Verify package parameter
    if (type(package) ~= "string" or #package == 0) then
        return
    end

    -- Convert the package
    self.language = fromJSON(package) or {}
end

function Language:get(name, default)
    -- Prepare default parameter
    default = (type(default) == "string") and default or ""

    -- Check if we have a loaded language
    if (not self.language) then
        return default
    end

    -- Verify name parameter
    if (type(name) ~= "string" or #name == 0) then
        return default
    end

    -- Get the string from the language
    return self.language[name] or default
end
