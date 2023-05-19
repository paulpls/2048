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
    if self.n == 0 then
        love.graphics.setColor(color("sq"))
    else
        love.graphics.setColor(color(self.n))
    end
    love.graphics.rectangle("fill", x, y, w, h)
end



return Square



