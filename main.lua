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



love.load = function (dt)
    --
    --  Load a new game
    --
    game    = Game:new()
    game.fs = false
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
    else
        game.fs = not game.fs
        love.window.setFullscreen(game.fs)
    end
end



love.quit = function ()
    --
    --  Girl, bye...
    --
    local msg = "Bye, Felicia"
    print("\n"..msg)
end



