local renderTable = {}
local renderKeys = {}
local cam = system.getStorage("camera")

-- local virtualWidth = 1280
-- local virtualHeight = 720
-- local defaultCanvas = love.graphics.newCanvas(virtualWidth, virtualHeight)
system.updateStorage("screenDimension", {w=love.graphics.getWidth(), h=love.graphics.getHeight()})
system.on("@update", function ()
  system.updateStorage("screenDimension", {w=love.graphics.getWidth(), h=love.graphics.getHeight()})
end)

system.render =  function (layer, func, fixed)
  fixed = fixed or false
  if renderTable[layer] == nil then
    renderTable[layer] = {}
    table.insert(renderKeys, layer)
  end
  table.insert(renderTable[layer], {func=func, fixed=fixed})
end

system.on("@renderer:render", function ()
  table.sort(renderKeys)

  -- love.graphics.setCanvas(defaultCanvas)
  -- love.graphics.clear(0.1, 0.1, 0.1, 1)
  
  for i, layer in ipairs(renderKeys) do
    for _, t in ipairs(renderTable[layer]) do

      if t.fixed == false then
        cam:start()
        t.func()
        cam:stop()
      else
        t.func()
      end
      
    end
    love.graphics.setColor(1, 1, 1)
  end
  
  --[[

  love.graphics.setCanvas()

  local screenWidth = love.graphics.getWidth() * 2
  local screenHeight = love.graphics.getHeight() * 2
  local scaleX = screenWidth / virtualWidth
  local scaleY = screenHeight / virtualHeight
  local scale = math.min(scaleX, scaleY)
  local offsetX = (screenWidth - virtualWidth * scale) / 4
  local offsetY = (screenHeight - virtualHeight * scale) / 4
  
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(defaultCanvas, 0, 0, 0, scale, scale)
  ]]

  renderTable = {}
  renderKeys = {}
end)