--[[
>   Project:        Debug Console
>   Developers:     Necktrox
--]]

-- TODO: implement settings

static "Settings"

function Settings:load()

end

function Settings:prepare()
    self.screenWidth, self.screenHeight = guiGetScreenSize()

    self.colors = { }

    self.fontface = { }
    self.fontface.content = "default-bold"

    self.fontsize = { }
    self.fontsize.content = 1.0

    self.linecount = 15
    self.lineheight = dxGetFontHeight(self.fontsize.content, self.fontface.content)
    self.tabheight = 30

    self.width = (0.9 * self.screenWidth)
    self.height = (self.tabheight + (self.lineheight * self.linecount))

    self.x = (self.screenWidth - self.width) / 2
    self.y = (self.screenHeight - self.height - 10)
end

function Settings:save()

end

function Settings:getSize()
    return self.width, self.height
end

function Settings:getPosition()
    return self.x, self.y
end
