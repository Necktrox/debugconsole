--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

-- TODO: implement settings

static "Settings"

function Settings:getVisibleTabs()
    return
    {
        {
            ["window"] = 1,
            ["codename"] = "info",
            ["friendlyname"] = "Information",
            ["color"] = {r = 0, g = 110, b = 255}
        },
        {
            ["window"] = 1,
            ["codename"] = "warning",
            ["friendlyname"] = "Warning",
            ["color"] = {r = 255, g = 220, b = 0}
        },
        {
            ["window"] = 1,
            ["codename"] = "error",
            ["friendlyname"] = "Error",
            ["color"] = {r = 255, g = 0, b = 0}
        }
    }
end

function Settings:getVisibleWindowCount()
    return 1
end

function Settings:getLanguage()
    return "en"
end

function Settings:getEveryTab()

end
