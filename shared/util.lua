--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

function class(name)
    -- Verify the name
    if (type(name) ~= "string" or #name == 0) then
        error("invalid name for a class", 2)
    end

    -- Create the class table
    local new = {}

    -- Create the metatable
    local metatable = {}

    -- Metamethod __call overwrite
    metatable.__call = function (self, ...)
        -- Continue when the method 'create' exists
        if (type(self.create) == "function") then
            return self:create(...)
        end
    end

    -- Metamethod __newindex overwrite (for late-method-binding for 'create')
    metatable.__newindex = function (self, k, v)
        -- Continue when we create the index 'create'
        if (type(k) == "string" and type(v) == "function" and k == "create") then
            -- Create the actual 'create' function
            return rawset(self, k,
                function (self, ...)
                    -- Create an instance
                    local instance = v(self, ...)

                    -- Check the instance type
                    if (type(instance) ~= "table") then
                        local text = "failed to create an instance for ".. name ..": "

                        if (type(instance) == "string") then
                            text = text .. instance
                        else
                            text = text .. "unknown error"
                        end
                        
                        error(text)
                    end

                    -- Bind the instance to the class
                    setmetatable(instance, {__index = self})

                    -- Run the constructor
                    if (type(instance.construct) == "function") then
                        instance:construct()
                    end

                    -- Return the instance
                    return instance
                end
            )
        else
            -- Apply the new value otherwise
            return rawset(self, k, v)
        end
    end

    -- Set the metatable for the class
    setmetatable(new, metatable)

    -- Create the class in the global environment
    _G[name] = new
end

function static(name)
    -- Verify the name
    if (type(name) ~= "string" or #name == 0) then
        error("invalid name for a static", 2)
    end

    -- Create the static table
    local new = {}

    -- Create the static in the global environment
    _G[name] = new
end

function bind(method, object)
    -- Verify the method parameter
    if (type(method) ~= "function") then
        error("cannot bind an invalid method to an object", 2)
    end

    -- Verify the object parameter
    if (type(object) ~= "table") then
        error("cannot bind an invalid object", 2)
    end

    -- Create a closure to call the function
    return function (...)
        -- Get data from the closure callback
        local environment = {
            source = source,
            this = this,
            eventName = eventName,
            client = client,
            sourceResource = sourceResource,
            sourceResourceRoot = sourceResourceRoot
        }  

        -- Apply a metatable to the environment to allow access to _G
        setmetatable(environment, {__index = _G})

        -- Change the environment for the method
        setfenv(method, environment)

        -- Call the method
        return method(object, ...)
    end
end
