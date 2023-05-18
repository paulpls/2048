--
--  2048
--  
--  Written by paulpls, inspired by Gabriele Cirulli
--



--
--  RNG
--
math.randomseed(os.time())
math.random()
math.random()
math.random()



--
--  Dependencies
--
require("class")
local Game = require("game")



--
--  Locals
--
local fullscreen = false



love.load = function (dt)
    --
    --  Load a new game
    --
    game = Game:new()
    fs = false
end



love.update = function (dt)
    game:update(dt)
end



love.draw = function ()
    game:draw()
end



love.keypressed = function (key)
    --
    --  Keyboard input
    --
    if key == "escape" or key == "q" then
        love.event.quit()
    elseif key == "f" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen)
    elseif key == "r" then
        game:restart()
    end
end



love.quit = function ()
    --
    --  Girl, bye...
    --
    local msg = "Bye, Felicia"
    print("\n"..msg)
end



