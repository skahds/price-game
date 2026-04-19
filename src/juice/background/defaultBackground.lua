local flux = system.getStorage("flux")

--background
local background = class()

function background:init()
  self.objects = {}
  self.distance = 200

  for x=0, 50 do
    for y=0, 50 do
      local randomColor = love.math.random(115, 150)/1000
      local randomAlpha = love.math.random()/2 + 0.5
      table.insert(self.objects, {
        x=(x-25)*self.distance,
        y=(y-25) *self.distance,
        size=125,
        color = {randomColor, randomColor, randomColor, randomAlpha}
      })
    end
  end
end

function background:update()
  local speed = 5
  local dt = system.getStorage("dt")
  for i, object in ipairs(self.objects) do
    object.x = object.x - speed * dt
    object.y = object.y - speed * dt

    if object.x + object.size < -self.distance*25 then
      object.x = object.x + self.distance*50
    end

    if object.y + object.size < -self.distance*25 then
      object.y = object.y + self.distance*50
    end
  end
end

function background:draw()
  local camera = main.getCamera()
  local camOffsetX, camOffsetY = -camera.x/4, -camera.y/4
  local currentColorMult = main.background.colorMult

  system.render(1, function ()
    love.graphics.setColor(0.1*currentColorMult[1], 0.1*currentColorMult[2], 0.1*currentColorMult[3])
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    for i, object in ipairs(self.objects) do
      local x, y = object.x, object.y
      local c1, c2, c3, a = unpack(object.color)

      love.graphics.setColor(c1*currentColorMult[1], c2*currentColorMult[2], c3*currentColorMult[3], a*currentColorMult[4])
      love.graphics.rectangle("fill", x + camOffsetX, y + camOffsetY, object.size, object.size)
    end
  end, true)
end

main.registerBackground("default", background)

main.playBackground("default")