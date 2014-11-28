--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

static "Renderer"

function Renderer:start()
    if (self.running) then
        return false
    end
    self.running = true

    -- Add the bind to the rendering process
    addEventHandler("onClientRender", root, self.bind)
end

function Renderer:prepare()
    -- Create a bind function for rendering
    self.bind = bind(self.render, self)

    -- General properties
    self.running = false

    -- TODO
    self.width, self.height = Settings:getSize()
    self.x, self.y = Settings:getPosition()
end

function Renderer:stop()
    if (not self.running) then
        return false
    end
    self.running = false

    -- Remove the bind to the rendering process
    removeEventHandler("onClientRender", root, self.bind)
end

function Renderer:render()
    -- Render the window
    self:renderWindow()

    -- Render the sidebar
    self:renderSidebar()

    -- Render the tabs
    self:renderTabs()

    -- Render the content
    self:renderContent()
end

function Renderer:renderWindow()
    
end

function Renderer:renderSidebar()
    
end

function Renderer:renderTabs()
    -- Get every visible tab
    local tabs = DebugConsole:getVisibleTabs()

    -- Abort if we don't have any visible tab
    if (#tabs == 0) then
        return
    end
end

function Renderer:renderContent()
    -- Get the active tab
    local tab = DebugConsole:getActiveTab()

    -- Abort here, if the active tab is invalid
    if (not tab) then
        return
    end
end
