local cam = system.getStorage("camera")
local flux = system.getStorage("flux")
local playerCam = {x=0, y=0, speed=500, zoom=1}

cam:followPos(playerCam)

system.on("@update", function ()
  local key = love.keyboard.isDown
  local dt = system.getStorage("dt")
  local speed = playerCam.speed / playerCam.zoom * dt
  local a = key("a")
  local d = key("d")
  local w = key("w")
  local s = key("s")
  if a then
    playerCam.x = playerCam.x - speed
  end
  if d then
    playerCam.x = playerCam.x + speed
  end
  if w then
    playerCam.y = playerCam.y - speed
  end
  if s then
    playerCam.y = playerCam.y + speed
  end
  
end)

system.on("main:currentPriceChanged", function ()
  local bar = system.getStorage("main:currentBar")
  if bar then
    if playerCam.tween then
      playerCam.tween:stop()
    end
    local targetX = bar.x+bar.width/2
    local targetY = bar.y+bar.height
    playerCam.tween = flux.to(playerCam, 0.2, {x=targetX, y=targetY})
  end
end)

function love.wheelmoved(x, y)
  if y > 0 and playerCam.zoom < 5 then
    playerCam.zoom = playerCam.zoom*1.2
  elseif y < 0 and playerCam.zoom > 0.5 then
    playerCam.zoom = playerCam.zoom/1.2
  end
  cam:setZoom(playerCam.zoom)
end
