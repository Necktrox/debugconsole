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
        if (type(new.create) == "function") then
            -- Create an instance
            local instance = new:create(...)

            -- Run the constructor
            if (type(instance.construct) == "function") then
                instance:construct()
            end

            -- Return the instance
            return instance
        end
    end

    -- Metamethod __index overwrite
    metatable.__index = new

    -- Set the metatable for the class
    setmetatable(new, metatable)

    -- Create the class in the global environment
    _G[name] = new
end

function static(name)
    -- Verify the name
    assert(type(name) == "string" and #name > 0, "invalid name for a class")

    -- Create the class table
    local new = {}

    -- Create the metatable
    local metatable = {}

     -- Metamethod __index overwrite
    metatable.__index = new

    -- Set the metatable for the class
    setmetatable(new, metatable)

    -- Create the class in the global environment
    _G[name] = new
end
