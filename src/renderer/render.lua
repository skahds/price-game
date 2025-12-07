local renderTable = {}
local renderKeys = {}
local cam = system.getStorage("camera")

local virtualWidth = 1280
local virtualHeight = 720
local scale = love.graphics.getDPIScale()
system.updateStorage("screenDimension", {w=virtualWidth, h=virtualHeight})

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
  love.graphics.draw(defaultCanvas, offsetX, offsetY, 0, scale, scale)

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