system = {}
main = {}

require('broadcast')
require('class')
require('utils')

function love.load()
  require('modLoading')

  system.call("@load")

end

function love.update(dt)
  system.updateStorage("dt", dt)

  system.call("@update")
end

function love.draw()
  system.call("@renderer:render")
end

function love.keyreleased(key)
  system.call("@keyreleased", key)
end

function love.mousereleased(x, y, button)
  system.call("@mouse:released", button)
end

function love.mousemoved( x, y, dx, dy, istouch )
  system.call("mouse:moved", {dx=dx, dy=dy})
end


local isDown = {false, false, false}
system.on("@update", function ()
  for i=1, 3 do
    if love.mouse.isDown(i) then
      if isDown[i] == false then
        system.call("@mouse:pressed")
        isDown[i] = true
      end
    else
      if isDown[i] == true then
        isDown[i] = false
      end
    end
  end
end)