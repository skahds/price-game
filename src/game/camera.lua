local cam = system.getStorage("camera")
local flux = system.getStorage("flux")
local playerCam = {x=0, y=0, speed=500, zoom=1.2}
local infos = {zoom=1.2}

cam:setZoom(playerCam.zoom)
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

  flux.to(infos, 0.2, {zoom=playerCam.zoom})
  cam:setZoom(infos.zoom)
end)

function main.tweenCamera(time, pos)
  if playerCam.tween then
    playerCam.tween:stop()
  end
  playerCam.tween = flux.to(playerCam, time, pos)
end

system.on("main:currentPriceChanged", function ()
  local bar = system.getStorage("main:currentBar")
  if bar then
    local targetX = bar.x+bar.width/2
    local targetY = bar.y+bar.height
    main.tweenCamera(0.2, {x=targetX, y=targetY})
  end
end)

system.on("@mouse:wheelmoved", function (t)
  local y=t.y
  if y > 0 and playerCam.zoom < 3 then
    playerCam.zoom = playerCam.zoom*1.2
  elseif y < 0 and playerCam.zoom > 0.7 then
    playerCam.zoom = playerCam.zoom/1.2
  end
end)

local hasPressed = false
system.on("@update", function ()
  if not love.keyboard.isDown("space") then
    hasPressed = false
    return
  end

  if hasPressed == true then
    return
  end
  hasPressed = true

  local bar = system.getStorage("main:currentBar")
  if bar then
    local targetX = bar.x+bar.width/2
    local targetY = bar.y+bar.height
    main.tweenCamera(0.2, {x=targetX, y=targetY})
  else
    main.tweenCamera(0.2, {x=0, y=0})
  end
end)

function main.screenSpaceToWorldPosition(screenX, screenY)
  local screenW = 1280
  local screenH = 720
  local camX = playerCam.x
  local camY = playerCam.y
  local camZ = playerCam.zoom
  
  local worldX = camX + (screenX - screenW / 2) / camZ
  local worldY = camY + (screenY - screenH / 2) / camZ
  
  return worldX, worldY
end

function main.worldPositionToScreenSpace(worldX, worldY)
  local screenW = 1280
  local screenH = 720
  local camX = playerCam.x
  local camY = playerCam.y
  local camZ = playerCam.zoom

  local screenX = camZ * (worldX - camX) + screenW / 2
  local screenY = camZ * (worldY - camY) + screenH / 2

  return screenX, screenY
end

function main.getCamera()
  return playerCam
end