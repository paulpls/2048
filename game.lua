--
--  Gameplay controller
--
local Game  = Class:new()



--
--  Grid defaults
--
Game.bgColor  = {1, 1, 1, 0.15}    --  Baxkground color
Game.gridSize = 4                  --  2 or greater
Game.margin   = 8                  --  Margin size



--
--  Dependencies
--
local Square = require("square")



Game.init = function (self, gamedata, size, margin, bg)
    --
    --  Initialize the grid
    --

    --  Set background color
    self.bg = bg or Game.bgColor

    if not gamedata then
        --  Start a new game with provided params or game defaults
        self.size   = size   or Game.gridSize
        self.margin = margin or Game.margin
        --  Start a new game
        self:restart()
    else
        --  TODO Load previous gamedata from file
    end
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
    self.sqSize = math.floor(math.min(wW, wH) / self.size)
    self.cX     = math.floor(wW / 2)
    self.cY     = math.floor(wH / 2)
    self.oX     = self.cX - math.floor((self.sqSize * self.size) / 2)
    self.oY     = self.cY - math.floor((self.sqSize * self.size) / 2)
end



Game.restart = function (self)
    --
    --  Completely restart the game
    --
    local g = {}
    local s = self.size
    for y=1, s do
        g[y] = {}
        for x=1, s do g[y][x] = Square:new() end
    end
    self:refresh()
    --  Reset grid
    self.grid = g
    --  Reset score
    self.score = 0
    --  Spawn two random squares
    local x1,y1  = math.random(1, s), math.random(1, s)
    local x2,y2  = math.random(1, s), math.random(1, s)
    repeat x2,y2 = math.random(1, s), math.random(1, s) until x1 ~= x2 or y1 ~= y2
    self:spawn(x1, y1)
    self:spawn(x2, y2)
end



Game.spawn = function (self, x, y, n)
    --
    --  Spawn a new number onto the grid at the specified coordinates
    --
    local x = x
    local y = y
    local n = n or 2 * math.random(1, 2)
    local g = self.grid
    local s = self.size
    g[y][x] = Square:new(n)
    --  Reset grid
    self.grid = g
end



Game.shift = function (self, dir)
    --
    --  Shift the tiles to fill any empty space
    --
    local g = self.grid
    local s = self.size

    --  Utilities
    local fill = function(t, rev)
        --
        --  Fill in space with empty squares
        --
        while #t < s do
            if rev then table.insert(t, 1, Square:new())
            else
                table.insert(t, Square:new())
            end
        end
        return t
    end
    local combine = function(t, rev)
        --
        --  Combine matching squares
        --
        if #t > 1 then
            local start,stop,d = 1, #t, 1
            if rev then start,stop,d = #t, 1, -1 end
            for i=start, stop, d do
                if (not rev and i + d <= #t) or (rev and i+d >= 1) then
                    local nextSq = t[i+d]
                    if t[i].n == nextSq.n then
                        self.score = self.score + t[i].n + t[i+d].n
                        t[i].n = t[i].n + table.remove(t, i+d).n
                    end
                end
            end
        end
        return t
    end

    --  Move and combine squares
    local rev = false
    if dir == "left" or dir == "right" then
        if dir == "right" then rev = true end
        for y=1, s do
            local t = {}
            for x=1, s do
                local sq = g[y][x]
                if sq.n ~= 0 then table.insert(t, sq) end
            end
            t = combine(t, rev)
            t = fill(t, rev)
            g[y] = t
        end
    elseif dir == "up" or dir == "down" then
        if dir == "down" then rev = true end
        for x=1, s do
            local t = {}
            for y=1, s do
                local sq = g[y][x]
                if sq.n ~= 0 then table.insert(t, sq) end
            end
            t = combine(t, rev)
            t = fill(t, rev)
            for y=1, s do g[y][x] = t[y] end
        end
    end

    --  Reset grid
    self.grid = g
end



Game.move = function (self, dir)
    --
    --  1)  Shift tiles in the specified direction, combining as necessary
    --  2)  Spawn a new tile if there is empty space
    --
    local g = self.grid
    local s = self.size
    --  Shift squares
    self:shift(dir)
    --  Add empty squares to list
    local empty = {}
    for y=1, s do
        for x=1, s do
            if g[y][x].n == 0 then
                table.insert(empty, {["x"]=x, ["y"]=y})
            end
        end
    end
    --  Spawn a new square in empty space
    if #empty > 0 then
        local sq = empty[math.random(1, #empty)]
        self:spawn(sq.x, sq.y)
    end
end



Game.update = function (self, dt)
    --
    --  Update square size
    --
    self:refresh()
end



Game.draw = function (self)
    --
    --  Draw the grid
    --
    for y=1, self.size do
        for x=1, self.size do
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



