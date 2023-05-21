--
--  Square prototype
--
local Square = Class:new()
local color  = require("colors")



Square.init = function (self, n)
    --
    --  Initialize a new square with its value
    --
    self.n = n or 0
end



Square.draw = function (self, x, y, w, h)
    --
    --  Draw the square
    --
    love.graphics.setColor(color(self.n))
    love.graphics.rectangle("fill", x, y, w, h)
end



return Square



