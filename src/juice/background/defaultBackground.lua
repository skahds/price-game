local flux = system.getStorage("flux")

local background = class()

function background:init()
  self.objects = {}
  self.distance = 200

  self.parallax = main.parallaxClass:new({
    parallaxFactor = 0.15,
    tileW          = 51 * self.distance,
    tileH          = 51 * self.distance,
  })

  -- grid dimensions
  self.cols = 51
  self.rows = 51
  self.halfCols = math.floor(self.cols / 2)
  self.halfRows = math.floor(self.rows / 2)

  for x = 0, self.cols - 1 do
    for y = 0, self.rows - 1 do
      local randomColor = love.math.random(115, 150) / 1000
      local randomAlpha = love.math.random() / 2 + 0.5
      table.insert(self.objects, {
        x = (x - self.halfCols) * self.distance,
        y = (y - self.halfRows) * self.distance,
        size = 125,
        color = { randomColor, randomColor, randomColor, randomAlpha }
      })
    end
  end
end

function background:update()
  -- no autonomous movement needed anymore;
  -- warping happens in draw based on camera position
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
      0.1 * currentColorMult[1],
      0.1 * currentColorMult[2],
      0.1 * currentColorMult[3]
    )
    love.graphics.rectangle("fill", 0, 0, 1280, 720)

    for i, object in ipairs(self.objects) do
      local c1, c2, c3, a = unpack(object.color)

      local sx, sy, scale = self.parallax:project(object.x, object.y)

      love.graphics.setColor(
        c1 * currentColorMult[1],
        c2 * currentColorMult[2],
        c3 * currentColorMult[3],
        a * currentColorMult[4]
      )
      love.graphics.rectangle("fill", sx, sy, object.size * scale, object.size * scale)
    end
  end, true)
end

main.registerBackground("default", background)