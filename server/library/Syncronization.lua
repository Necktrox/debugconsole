--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "Syncronization"

function Syncronization:prepare()
    -- Name of the resource
    self.resourceName = DebugConsole.resourceName or "debugconsole"

    -- Use the md5-hash for the event name
    self.eventName = md5(self.resourceName)

    -- Category bindings
    self.binds = {}

    -- Add the event interface for the clients
    self:createClientInterface()
end

function Syncronization:createClientInterface()
    -- Add the interface for the client event
    addEvent(self.eventName, true)

    -- Bind the handler for the client event
    addEventHandler(self.eventName, resourceRoot, bind(self.handleClientEvent, self))
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

function Syncronization:handleClientEvent(category, ...)
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

function Syncronization:push(player, category, ...)
    -- Verify the player
    assert(isElement(player) and getElementType(player) == "player", "invalid player")

    -- Verify the category parameter
    assert(type(category) == "string" and #category > 0, "invalid category")

    -- Send the information to the server (softly with latent event)
    triggerLatentClientEvent(player, self.eventName, resourceRoot, category, ...)
end
