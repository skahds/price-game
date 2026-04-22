local flux = system.getStorage("flux")
local background = class()

local colorLimit = {
  {0.4, 0.8},
  {0.7, 1},
  {0.7, 1},
}
local function getRandomColor()
  return {
    love.math.random(colorLimit[1][1]*10, colorLimit[1][2]*10)/10,
    love.math.random(colorLimit[2][1]*10, colorLimit[2][2]*10)/10,
    love.math.random(colorLimit[3][1]*10, colorLimit[3][2]*10)/10,
    1
  }
end

function background:init()
  self.objects = {}

  self.parallax = main.parallaxClass:new({
    parallaxFactor = 0.15,
    tileW          = 5000,
    tileH          = 5000,
  })

  local numberOfThings = 100

  for i = 1, numberOfThings * 30 do
    local x = love.math.random(-2500, 2500)
    local y = love.math.random(-2500, 2500)

    local layer = love.math.random(13, 19)/10
    local size = (love.math.random(8, 12)/10) * (layer-0.6)
    table.insert(self.objects, {
      x = x,
      y = y,
      layer=layer/10,
      size = size,
      color = getRandomColor(),
      image = "light_12"
    })
  end

  for i = 1, numberOfThings * 30 do
    local x = love.math.random(-2500, 2500)
    local y = love.math.random(-2500, 2500)

    local layer = love.math.random(13, 19)/10
    local size = (love.math.random(8, 12)/10) * (layer-0.6)
    table.insert(self.objects, {
      x = x,
      y = y,
      layer=layer/10,
      size = size,
      color = getRandomColor(),
      image = "shine_12"
    })
  end

  for i = 1, numberOfThings*2 do
    local x = love.math.random(-2500, 2500)
    local y = love.math.random(-2500, 2500)

    local layer = love.math.random(13, 19)/10
    local size = (love.math.random(8, 12)/10) * (layer-0.6)
    table.insert(self.objects, {
      x = x,
      y = y,
      layer=layer/10,
      size = size,
      color = getRandomColor(),
      image = "light_256"
    })
  end

  for i = 1, numberOfThings do
    local x = love.math.random(-2500, 2500)
    local y = love.math.random(-2500, 2500)

    local layer = love.math.random(13, 19)/10
    local size = (love.math.random(15, 19)/10) * (layer-0.6)
    table.insert(self.objects, {
      x = x,
      y = y,
      layer=layer/10,
      size = size,
      color = getRandomColor(),
      image = "light_512"
    })
  end

  table.sort(self.objects, function (a, b)
    return a.layer < b.layer
  end)
end

function background:update()
  local dt = system.getStorage("dt")
  for i, obj in ipairs(self.objects) do
    obj.x = obj.x - 5 * dt
    obj.y = obj.y - 5 * dt
  end
end

function background:draw()
  local currentColorMult = main.background.colorMult

  system.render(1, function()
    love.graphics.setColor(
      0.04 * currentColorMult[1],
      0.04 * currentColorMult[2],
      0.12 * currentColorMult[3]
    )
    love.graphics.rectangle("fill", 0, 0, 1280, 720)

    for i, object in ipairs(self.objects) do
      local c1, c2, c3, a = unpack(object.color)

      local sx, sy, scale = self.parallax:project(object.x, object.y, object.layer)

      love.graphics.setColor(
        c1 * currentColorMult[1],
        c2 * currentColorMult[2],
        c3 * currentColorMult[3],
        a * currentColorMult[4]
      )
      love.graphics.draw(system.getImage(object.image), sx, sy, 0, object.size * scale, object.size * scale)
    end
  end, true)
end

main.registerBackground("tranquil", background)