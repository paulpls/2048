--
--  Font management
--
local Font = Class:new()
Font._path   = "assets/font/pixel.png"
Font._glyphs = " ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
Font._w      = 11
Font._h      = 16
Font._k      = 2
Font._bold   = 2



function Font:init(path, glyphs, w, h, k, bold)
    --
    --  Initialize font
    --
    self.path   = path   or Font._path
    self.glyphs = glyphs or Font._glyphs
    self.w      = w      or Font._w
    self.h      = h      or Font._h
    self.k      = k      or Font._k
    self.bold   = bold  or Font._bold
    --  Configure font face
    self.face   = love.graphics.newImageFont(self.path, self.glyphs)
end



function Font:set()
    --
    --  Set the font
    --
    love.graphics.setFont(self.face)
end



return Font



