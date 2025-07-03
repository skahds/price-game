local screenWidth, screenHeight = love.graphics.getDimensions()
system.updateStorage("screenDimension", {w=screenWidth, h=screenHeight})

system.on("@update", function ()
  screenWidth, screenHeight = love.graphics.getDimensions()
  system.updateStorage("screenDimension", {w=screenWidth, h=screenHeight})
end)