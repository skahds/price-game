local cam = {x=0, y=0, zoom = 1}

function cam:start()
  love.graphics.push()
  local screenWidth, screenHeight = system.getStorage("screenDimension").w, system.getStorage("screenDimension").h

  --translate to the middle of the screen
  love.graphics.translate(screenWidth/2, screenHeight/2)
  love.graphics.scale(cam.zoom)
  love.graphics.translate(-self.x, -self.y)
end

function cam:stop()
  love.graphics.pop()
end

function cam:setPosition(x, y)
  self.x = x
  self.y = y
end

function cam:setZoom(factor)
  self.zoom = factor
end

function cam:followPos(pos)
  system.on("@update", function ()
    self.x = pos.x
    self.y = pos.y
  end)
end

system.on("@update", function ()
  local screenWidth, screenHeight = system.getStorage("screenDimension").w, system.getStorage("screenDimension").h
  local mouseX, mouseY = love.mouse.getPosition()
  local relativeMouseX = mouseX - (screenWidth / 2)
  local relativeMouseY = mouseY - (screenHeight / 2)
  local unzoomedX = relativeMouseX / cam.zoom
  local unzoomedY = relativeMouseY / cam.zoom
  local worldX = unzoomedX + cam.x
  local worldY = unzoomedY + cam.y
  
  

  system.updateStorage("mouse", {x=worldX, y=worldY})
end)

system.updateStorage("camera", cam)