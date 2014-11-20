--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "Syncronization"

function Syncronization:prepare()
    -- Name of the resource
    local resourceName = DebugConsole.resourceName or "debugconsole"

    -- Use the md5-hash for the event name
    self.eventName = md5(resourceName)

    -- Category bindings
    self.binds = {}

    -- Add the event interface for the server
    self:createServerInterface()
end

function Syncronization:createServerInterface()
    -- Add the server event
    addEvent(self.eventName, true)

    -- Bind the handler for the server event
    addEventHandler(self.eventName, resourceRoot, bind(self.handleServerEvent, self))
end

function Syncronization:add(category, callback)
    -- Verify the category parameter
    assert(type(category) == "string" and #category > 0, "invalid category")

    -- Verify the callback parameter
    assert(type(callback) == "function", "invalid callback")

    -- Check if a callback for that category already exists
    if (self.binds[category]) then
        return
    end

    -- Bind the callback to this category
    self.binds[category] = callback
end

function Syncronization:handleServerEvent(category, ...)
    -- Verify the category parameter
    if (type(category) == "string" and #category > 0) then
        -- Get the handler by category
        local handler = self.binds[category]

        -- Call the handler if it's valid
        if (handler) then
            return handler(...)
        end
    end

    -- Handle an undefined category
    DebugConsole:output("Exception in handling an undefined category '" .. tostring(category) .. "' in the interface")
end

function Syncronization:push(category, ...)
    -- Verify the category parameter
    assert(type(category) == "string" and #category > 0, "invalid category")

    -- Send the information to the server (softly with latent event)
    triggerLatentServerEvent(self.eventName, resourceRoot, category, localPlayer, ...)
end
