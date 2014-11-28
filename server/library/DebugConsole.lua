--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "DebugConsole"

function DebugConsole:start()
    -- Prepare the class before usage
    self:prepare()

    -- Prepare the syncronization class
    Syncronization:prepare()

    -- Bind handlers for packages
    Syncronization:add("permission", bind(self.handlePermissionRequest, self))
end

function DebugConsole:stop()
    -- Nothing to do here
end

function DebugConsole:prepare()
    -- Name of the resource
    self.resourceName = getResourceName(resource) or "debugconsole"
end

function DebugConsole:hasPlayerPermission(player)
    -- Validate the player
    if (not isElement(player) or getElementType(player) ~= "player") then
        return false
    end

    -- Return the permission boolean
    return hasObjectPermissionTo(player, "command.debugscript", false)
end

function DebugConsole:handlePermissionRequest(player)
    -- Validate the player
    if (not isElement(player) or getElementType(player) ~= "player") then
        return
    end

    -- Check if the player has permission for the debugconsole
    local access = self:hasPlayerPermission(player)

    -- Send the permission data to the player
    Syncronization:push("permission", player, access)
end

function DebugConsole:output(formatstring, ...)
    -- Verify the formatstring
    assert(type(formatstring) == "string" and #formatstring > 0, "invalid formatstring")

    -- Apply the format
    formatstring = formatstring:format(...)

    -- Add the resource name as prefix
    formatstring = "Server, [" .. (self.resourceName) .. "] ".. formatstring

    -- Write the debug string
    outputDebugString(formatstring)
end
