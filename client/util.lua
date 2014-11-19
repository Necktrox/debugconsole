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
