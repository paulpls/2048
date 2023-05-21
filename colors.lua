--
--  Colors
--



local v = function (n)
    --
    --  Value rules
    --
    return math.pow(2, n)
end



local hsv = function (h, s, v)
    --
    --  HSV color modelling
    --
    --  0 <= h <= 360
    --  0 <= s <= 100
    --  0 <= v <= 100
    --
    h = h / 60
    s = s / 100
    v = v / 100
    if s <= 0 then return {v, v, v} end
    local c = v * s
    local x = c * (1 - math.abs((h % 2) - 1))
    local m = v - c
    local colors = {
        {c, x, 0},
        {x, c, 0},
        {0, c, x},
        {0, x, c},
        {x, 0, c},
        {c, 0, x}
    }
    h = 1 + math.floor(h) % 6
    local r,g,b = unpack(colors[h])
    return {
        r + m,
        g + m,
        b + m
    }
end



--
--  Color definitions
--
local colors = {
    ["bg"]  = {250  , 54.5, 4.3 }, -- Window background
    ["fg"]  = {240  , 10.1, 92.9}, -- Window foreground (text, etc)
    [0]     = {257.1, 38.9, 7.1 }, -- Empty square color
    [v(1)]  = {245.5, 41.1, 42  }, -- 2
    [v(2)]  = {235.1, 45.2, 52.9}, -- 4
    [v(3)]  = {226.9, 41.3, 60.8}, -- 8
    [v(4)]  = {166  , 100 , 75.7}, -- 16
    [v(5)]  = {166  , 100 , 85.1}, -- 32
    [v(6)]  = {31   , 100 , 91  }, -- 64
    [v(7)]  = {32   , 94.9, 100 }, -- 128
    [v(8)]  = {15.4 , 100 , 90.2}, -- 256
    [v(9)]  = {15.5 , 98.8, 100 }, -- 512
    [v(10)] = {353  , 100 , 91  }, -- 1024
    [v(11)] = {352.9, 96.1, 100 }, -- 2048
    [v(12)] = {245.6, 82.2, 66.3}, -- 4096
    [v(13)] = {245.8, 88.6, 100 }, -- 8192
}



--
--  Return a function that gives a color by value, or black if undefined
--
return function (n)
    if colors[n] then
        return hsv(unpack(colors[n]))
    else
        return hsv(250, 54.5, 4.3)
    end
end



