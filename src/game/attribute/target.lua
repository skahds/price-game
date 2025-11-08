local pipeline = main.getPipeline("main")

system.on("main:entityTriggered", function (ent)
  if ent.target then
    local t = ent.target
    local shape = t.shape
    local gridX, gridY = main.grid.entityToGrid(ent)
    local news = main.grid.getNewsInGrid(gridX-math.floor(shape.w/2), gridY-math.floor(shape.h/2), shape.w, shape.h)
    
    if news == nil then
      return
    end

    for i, n in ipairs(news) do
      local time = 0.05+0.2/(i/2)
      if n.index ~= ent.index then
        pipeline:add(0, function ()
          t.onActivate(ent, n)
          system.call("main:targetEntityTriggered", ent, n)
        end)
      end
    end
  end
end)