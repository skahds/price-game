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