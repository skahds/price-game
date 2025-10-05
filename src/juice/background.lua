local objects = {}
local distance = 200

for x=0, 30 do
  for y=0, 30 do
    local randomColor = love.math.random(115, 150)/1000
    local randomAlpha = love.math.random()/2 + 0.5
    table.insert(objects, {
      x=x*distance,
      y=y*distance,
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

    if object.x + object.size < 0 then
      object.x = object.x + distance*30
    end

    if object.y + object.size < 0 then
      object.y = object.y + distance*30
    end
  end
end)

system.on("@draw", function ()
  system.render(1, function ()
    for i, object in ipairs(objects) do
      love.graphics.setColor(unpack(object.color))
      love.graphics.rectangle("fill", object.x, object.y, object.size, object.size)
    end
  end, true)
end)