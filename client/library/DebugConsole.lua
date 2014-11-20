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
    Syncronization:add("permission", bind(self.handlePermissionResponse, self))
    Syncronization:add("language", bind(self.handleLanguageResponse, self))

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

    -- Setting if we syncronized once
    self.firstrun = true
end

function DebugConsole:handlePermissionResponse(access)
    -- DEBUG: permission info
    self:output("Permission granted: %s", (access and "yes" or "no"))

    -- Apply the value
    self.access = access

    if (self.firstrun) then
        -- Require the language package when we have access
        if (access) then
            -- Get the player's UI language
            local language = Settings:getLanguage()

            -- Require the language package
            Syncronization:push("language", language)
        end

        -- First run is done
        self.firstrun = false
    else
        -- Hide the debug console incase we don't have rights anymore
        if (not access) then
            -- TODO: add this functionality
        end
    end
end

function DebugConsole:handleLanguageResponse(package)
    -- Pass the package to the Language class
    Language:apply(package)

    -- DEBUG: language info
    self:output("Received language packet, test: newtab = %q", Language:get("newtab"))
end

function DebugConsole:createTabsFromSettings()
    -- Get list with visible windows
    local windows = Settings:getVisibleWindowCount()
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
