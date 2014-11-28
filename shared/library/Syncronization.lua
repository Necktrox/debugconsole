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

    -- Add the event interface
    self:createInterface()
end

function Syncronization:createInterface()
    -- Add the server event
    addEvent(self.eventName, true)

    -- Bind the handler for the server event
    addEventHandler(self.eventName, resourceRoot, bind(self.handleInterfaceEvent, self))
end

function Syncronization:add(category, callback)
    -- Verify the category parameter
    if (type(category) ~= "string" or #category == 0) then 
        error("invalid category", 2)
    end

    -- Verify the callback parameter
    if (type(callback) ~= "function") then 
        error("invalid callback", 2)
    end

    -- Check if a callback for that category already exists
    if (self.binds[category]) then
        return
    end

    -- Bind the callback to this category
    self.binds[category] = callback
end

function Syncronization:handleInterfaceEvent(category, ...)
    -- Verify the category parameter
    if (type(category) == "string" and #category > 0) then
        -- Get the handler by category
        local handler = self.binds[category]

        -- Call the handler if it's valid
        if (type(handler) == "function") then
            return handler(...)
        end
    end

    -- Handle an undefined category
    DebugConsole:output("Exception in handling an undefined category '" .. tostring(category) .. "' in the interface")
end

function Syncronization:push(category, ...)
    -- Verify the category parameter
    if (type(category) ~= "string" or #category == 0) then 
        error("invalid category", 2)
    end

    if (triggerLatentServerEvent) then
        -- Clientside --
        triggerLatentServerEvent(self.eventName, resourceRoot, category, localPlayer, ...)
    else
        -- Serverside --
        local args = {...}
        local player = args[1]

        -- Verify the player
        if (not isElement(player) or getElementType(player) ~= "player") then 
            error("invalid player", 2)
        end

        triggerLatentClientEvent(player, self.eventName, resourceRoot, category, ...)
    end
end
