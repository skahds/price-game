local virtualWidth = 1280
local virtualHeight = 720

system.updateStorage("realMouse", {x=0, y=0})
system.updateStorage("system:screenScale", {ox=0, oy=0, scale=1})

system.on("@update", function ()
  local scale = system.getStorage("system:screenScale")
  local scl = scale.scale
  local offsetX = scale.ox
  local offsetY = scale.oy
  local mousePosX, mousePosY = love.mouse.getPosition()
  mousePosX = (mousePosX-offsetX) / scl
  mousePosY = (mousePosY-offsetY) / scl

  mousePosX = math.max(math.min(mousePosX, virtualWidth), 0)
  mousePosY = math.max(math.min(mousePosY, virtualHeight), 0)
  system.updateStorage("realMouse", {x=mousePosX, y=mousePosY})
end)