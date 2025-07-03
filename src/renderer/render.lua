local renderTable = {}
local renderKeys = {}
local cam = system.getStorage("camera")

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
  

  renderTable = {}
  renderKeys = {}
end)