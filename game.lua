--
--  Gameplay controller
--
local Game  = Class:new()



--
--  Grid defaults
--
Game.bgColor   = {1, 1, 1, 0.15}
Game.gridSizeX = 4
Game.gridSizeY = 4
Game.margin    = 8



--
--  Dependencies
--
local Square = require("square")




Game.init = function (self, gamedata, sizeX, sizeY, margin, bg)
    --
    --  Initialize the grid
    --

    --  Set background color
    self.bg      = bg or Game.bgColor

    if not gamedata then
        --  Start a new game with provided params or game defaults
        self.sizeX  = sizeX  or Game.gridSizeX
        self.sizeY  = sizeY  or Game.gridSizeY
        self.margin = margin or Game.margin
        self.full   = false
        --  Get rendering parameters based on window size
        self:refresh()
        --  Build the grid
        self.grid   = {}
        for y=1, self.sizeY do self.grid[y] = {} end
    else
        --  TODO Load previous gamedata from file
    end
    --  Spawn two random squares
    self:spawn()
    self:spawn()
end



Game.getX = function (self, x)
    --
    --  Get square x coordinate for rendering
    --
    return (x-1) * self.sqSize + self.oX
end



Game.getY = function (self, y)
    --
    --  Get square y coordinate for rendering
    --
    return (y-1) * self.sqSize + self.oY
end



Game.refresh = function (self)
    --
    --  Refresh centerpoint, render offset, and square size
    --
    local wW,wH = love.graphics.getDimensions()
    self.sqSize = math.floor(math.min(wW, wH) / math.min(self.sizeX, self.sizeY))
    self.cX     = math.floor(wW / 2)
    self.cY     = math.floor(wH / 2)
    self.oX     = self.cX - math.floor((self.sqSize * self.sizeX) / 2)
    self.oY     = self.cY - math.floor((self.sqSize * self.sizeY) / 2)
end



Game.spawn = function (self, n)
    --
    --  Spawn a new number onto the grid
    --
    if not self.full then
        --  Randomize new value and coordinates
        local n      = n or 2 * math.random(1, 2)
        local x,y    = math.random(1, self.sizeX), math.random(1, self.sizeY)
        repeat x,y   = math.random(1, self.sizeX), math.random(1, self.sizeY) until not self.grid[y][x]
        --  Create a new square
        local sqX    = self.oX + ((x-1) * self.sqSize)
        local sqY    = self.oY + ((y-1) * self.sqSize)
        self.grid[y][x] = Square:new(n)
    end
end



Game.update = function (self, dt)
    --  Update square size
    self:refresh()
end



Game.draw = function (self)
    for y=1, self.sizeY do
        for x=1, self.sizeX do
            --  Get coords and dimensions
            local oX,oY = self:getX(x), self:getY(y)
            local w,h   = self.sqSize - 1, self.sqSize - 1
            --  Draw the grid background
            love.graphics.setColor(self.bg)
            love.graphics.rectangle("fill", oX, oY, w, h)
            --  Draw squares
            local sq = self.grid[y][x]
            if sq then
                sq:draw(oX, oY, w, h)
            end
        end
    end
end



return Game



