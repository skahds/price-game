local flux = system.getStorage("flux")

local background = class()

function background:init()
  self.objects = {}
  self.distance = 200

  -- parallax factor: 0 = doesn't move at all, 1 = moves with camera
  self.parallaxFactor = 0.15
  -- how much the zoom is dampened (0 = no zoom effect, 1 = full zoom)
  self.zoomFactor = 0.08

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
  local camera = main.getCamera()
  local currentColorMult = main.background.colorMult

  -- parallax offset: background moves at a fraction of camera speed
  local camOffsetX = -camera.x * self.parallaxFactor
  local camOffsetY = -camera.y * self.parallaxFactor

  -- parallax zoom: interpolate between 1 and camera.zoom
  local parallaxZoom = 1 + (camera.zoom - 1) * self.zoomFactor

  -- total grid size for wrapping
  local gridW = self.cols * self.distance
  local gridH = self.rows * self.distance

  -- screen center (wrap anchor)
  local screenW, screenH = love.graphics.getDimensions()
  local cx, cy = screenW / 2, screenH / 2

  system.render(1, function()
    love.graphics.setColor(
      0.1 * currentColorMult[1],
      0.1 * currentColorMult[2],
      0.1 * currentColorMult[3]
    )
    love.graphics.rectangle("fill", 0, 0, screenW, screenH)

    for i, object in ipairs(self.objects) do
      local c1, c2, c3, a = unpack(object.color)

      -- raw world position with parallax offset
      local wx = object.x + camOffsetX
      local wy = object.y + camOffsetY

      -- wrap so the tile stays within one grid-width of screen center
      wx = wx - math.floor((wx - cx) / gridW + 0.5) * gridW
      wy = wy - math.floor((wy - cy) / gridH + 0.5) * gridH

      -- apply parallax zoom around screen center
      local sx = cx + (wx - cx) * parallaxZoom
      local sy = cy + (wy - cy) * parallaxZoom
      local scaledSize = object.size * parallaxZoom

      love.graphics.setColor(
        c1 * currentColorMult[1],
        c2 * currentColorMult[2],
        c3 * currentColorMult[3],
        a * currentColorMult[4]
      )
      love.graphics.rectangle("fill", sx, sy, scaledSize, scaledSize)
    end
  end, true)
end

main.registerBackground("default", background)

main.playBackground("default")