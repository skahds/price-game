--background
local objects = {}
local distance = 200

for x=0, 50 do
  for y=0, 50 do
    local randomColor = love.math.random(115, 150)/1000
    local randomAlpha = love.math.random()/2 + 0.5
    table.insert(objects, {
      x=(x-25)*distance,
      y=(y-25) *distance,
      size=125,
      color = {randomColor, randomColor, randomColor, randomAlpha}
    })
  end
end

system.on("@update", function ()
  local speed = 5
  local dt = system.getStorage("dt")
  for i, object in ipairs(objects) do
    object.x = object.x - speed * dt
    object.y = object.y - speed * dt

    if object.x + object.size < -distance*25 then
      object.x = object.x + distance*50
    end

    if object.y + object.size < -distance*25 then
      object.y = object.y + distance*50
    end
  end
end)

system.on("@draw", function ()
  local camera = main.getCamera()
  local camOffsetX, camOffsetY = -camera.x/4, -camera.y/4

  system.render(1, function ()
    for i, object in ipairs(objects) do
      local x, y = object.x, object.y

      love.graphics.setColor(unpack(object.color))
      love.graphics.rectangle("fill", x + camOffsetX, y + camOffsetY, object.size, object.size)
    end
  end, true)
end)