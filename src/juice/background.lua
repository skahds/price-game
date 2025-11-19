local flux = system.getStorage("flux")

--background
local objects = {}
local distance = 200
local currentColorMult = {1, 1, 1, 1}

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
    -- love.graphics.setColor(0.38, 0.86, 0.96)
    love.graphics.setColor(0.1*currentColorMult[1], 0.1*currentColorMult[2], 0.1*currentColorMult[3])
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
    
    for i, object in ipairs(objects) do
      local x, y = object.x, object.y
      local c1, c2, c3, a = unpack(object.color)

      love.graphics.setColor(c1*currentColorMult[1], c2*currentColorMult[2], c3*currentColorMult[3], a*currentColorMult[4])
      love.graphics.rectangle("fill", x + camOffsetX, y + camOffsetY, object.size, object.size)
    end
  end, true)
end)

system.on("main:sceneChanged", function ()
  local scene = system.getStorage("main:currentScene")
  local time = 4

  if scene == "levelSelect" then
    flux.to(currentColorMult, time, {1.2, 1.8, 1.5})
  elseif scene == "play" then
    flux.to(currentColorMult, time, {1.2, 1.3, 1.8})
  else
    flux.to(currentColorMult, time, {1, 1, 1})
  end
end)