--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "DebugConsole"

function DebugConsole:start()
    -- Prepare the class before usage
    self:prepare()

    -- Prepare the settings class
    Settings:prepare()

    -- Prepare the syncronization class
    Syncronization:prepare()

    -- Prepare the rendering class
    Renderer:prepare()

    -- Bind handlers for packages
    Syncronization:add("permission", bind(self.handlePermissionResponse, self))

    -- Require the permission package
    Syncronization:push("permission")
end

function DebugConsole:stop()
    -- Nothing to do here
end

function DebugConsole:prepare()
    -- Name of the resource
    self.resourceName = getResourceName(resource) or "debugconsole"

    -- Permission to use the debug console
    self.access = false

    -- Table with every tab
    self.tabs = { }

    -- TODO
    self.activetab = false
end

function DebugConsole:getVisibleTabs()
    local visible = { }

    for index, tab in pairs(self.tabs) do
        if (tab:visible()) then
            visible[#visible + 1] = tab
        end
    end

    return visible
end

function DebugConsole:getActiveTab()
    if (self.activetab) then
        return self.tabs[self.activetab]
    else
        return false
    end
end

function DebugConsole:handlePermissionResponse(access)
    -- DEBUG: permission info
    self:output("Permission granted: %s", (access and "yes" or "no"))

    -- Start/Stop rendering process
    if (not self.access and access) then
        Renderer:start()
    elseif (self.access and not access) then
        Renderer:stop()
    end

    -- Apply the value
    self.access = access
end

function DebugConsole:output(formatstring, ...)
    -- Verify the formatstring
    assert(type(formatstring) == "string" and #formatstring > 0, "invalid formatstring")

    -- Apply the format
    formatstring = formatstring:format(...)

    -- Add the resource name as prefix
    formatstring = "Client, [" .. (self.resourceName) .. "] ".. formatstring

    -- Write the debug string
    outputDebugString(formatstring)
end
