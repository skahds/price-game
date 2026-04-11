local renderTable = {}
local renderKeys = {}
local cam = system.getStorage("camera")

local virtualWidth = 1280
local virtualHeight = 720
local scale = love.graphics.getDPIScale()
system.updateStorage("screenDimension", {w=virtualWidth, h=virtualHeight})

local pixelCanvas = love.graphics.newCanvas(virtualWidth, virtualHeight)

system.render =  function (layer, func, fixed)
  fixed = fixed or false
  if renderTable[layer] == nil then
    renderTable[layer] = {}
    table.insert(renderKeys, layer)
  end
  table.insert(renderTable[layer], {func=func, fixed=fixed})
end

system.on("renderer:render", function ()
  table.sort(renderKeys)

  
  love.graphics.setCanvas{defaultCanvas, stencil=true}
  love.graphics.clear(0.1, 0.1, 0.1, 1)
  
  for i, layer in ipairs(renderKeys) do
    for _, t in ipairs(renderTable[layer]) do

      if t.fixed == false then
        cam:start()
        t.func()
        cam:stop()
      else
        t.func()
      end
      love.graphics.setColor(1, 1, 1)
      love.graphics.setShader()
    end
  end
  
  love.graphics.setCanvas()

  local screenWidth = love.graphics.getWidth()
  local screenHeight = love.graphics.getHeight()
  local scaleX = screenWidth / virtualWidth
  local scaleY = screenHeight / virtualHeight
  local scale = math.min(scaleX, scaleY)
  local offsetX = (screenWidth - virtualWidth * scale) / 2
  local offsetY = (screenHeight - virtualHeight * scale) / 2
  
  love.graphics.setColor(1, 1, 1, 1)
  
  if system.getStorage("system:shader") then
    love.graphics.setShader(system.getStorage("system:shader"))
  end
  love.graphics.draw(defaultCanvas, offsetX, offsetY, 0, scale, scale)
  love.graphics.setShader()
  -- -- Pass 1: defaultCanvas → pixelCanvas through pixelation shader
  -- love.graphics.setCanvas(pixelCanvas)
  -- love.graphics.clear()
  -- local pixShader = system.getStorage("system:pixelShader")
  -- if pixShader then
  --   love.graphics.setShader(pixShader)
  -- end
  -- love.graphics.draw(defaultCanvas, 0, 0)
  -- love.graphics.setShader()

  -- -- Pass 2: pixelCanvas → screen through your existing shader
  -- love.graphics.setCanvas()
  -- if system.getStorage("system:shader") then
  --   love.graphics.setShader(system.getStorage("system:shader"))
  -- end
  -- love.graphics.draw(pixelCanvas, offsetX, offsetY, 0, scale, scale)
  -- love.graphics.setShader()

  if scaleX > scaleY then -- Pillarboxing (black bars on sides)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, offsetX, screenHeight) -- Left bar
    love.graphics.rectangle("fill", screenWidth - offsetX, 0, offsetX, screenHeight) -- Right bar
  elseif scaleY > scaleX then -- Letterboxing (black bars on top/bottom)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("fill", 0, 0, screenWidth, offsetY) -- Top bar
    love.graphics.rectangle("fill", 0, screenHeight - offsetY, screenWidth, offsetY) -- Bottom bar
  end
  system.updateStorage("system:screenScale", {ox=offsetX, oy=offsetY, scale=scale})


  renderTable = {}
  renderKeys = {}
end)