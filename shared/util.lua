--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

function class(name)
    -- Verify the name
    assert(type(name) == "string" and #name > 0, "invalid name for a class")

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
    assert(type(name) == "string" and #name > 0, "invalid name for a class")

    -- Create the static table
    local new = {}

    -- Create the static in the global environment
    _G[name] = new
end

function bind(method, object)
    -- Verify the method parameter
    assert(type(method) == "function", "cannot bind an invalid method to an object")

    -- Verify the object parameter
    assert(type(object) == "table", "cannot bind an invalid object")

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
