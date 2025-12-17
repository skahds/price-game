-- jit.off()

love.graphics.setDefaultFilter("nearest", "nearest")
system = {}
main = {}
defaultCanvas = love.graphics.newCanvas(1280, 720)

require("errorHandler")
require('broadcast')
require('class')
require('utils')
require("saveSystem")

function love.load()
  love.window.setTitle("Chart Weaver")
  require('modLoading')

  system.call("@load")
end

function love.update(dt)
  system.updateStorage("dt", dt)

  system.call("@update")
end

function love.draw()
  system.call("@draw")
  system.call("renderer:render")
end

function love.keyreleased(key)
  system.call("@keyreleased", key)
end

function love.mousereleased(x, y, button)
  system.call("@mouse:released", button)
end

function love.mousemoved( x, y, dx, dy, istouch )
  system.call("@mouse:moved", {dx=dx, dy=dy})
end

function love.wheelmoved(x, y)
  system.call("@mouse:wheelmoved", {x=x, y=y})
end


local isDown = {false, false, false}
system.on("@update", function ()
  for i=1, 3 do
    if love.mouse.isDown(i) then
      if isDown[i] == false then
        system.call("@mouse:pressed", i)
        isDown[i] = true
      end
    else
      if isDown[i] == true then
        isDown[i] = false
      end
    end
  end
end)