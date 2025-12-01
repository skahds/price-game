local pipeline = main.getPipeline("main")

system.on("main:entityTriggered", function (ent)
  if ent then
    local t = ent
    local target = ent.target
    if target == nil then
      return
    end

    local gridX, gridY
    local width, height
    local shape = target.shape
    if ent.isCard then
      local mouse = system.getStorage("mouse")
      gridX, gridY = main.grid.toGrid(mouse.x, mouse.y)
      width, height = 16, 16
    elseif ent.isNews then
      gridX, gridY = main.grid.entityToGrid(ent)
      width, height = ent.width, ent.height
    end

    local news = main.grid.getNewsInGrid(gridX-math.floor(shape.w/2), gridY-math.floor(shape.h/2), shape.w, shape.h)
    
    if news == nil then
      return
    end

    local x, y = main.grid.gridToPos(gridX, gridY)
    local pos = {x=x, y=y, width=width, height=16}

    for i, n in ipairs(news) do
      local time = 0.05+0.2/(i/2)
      if n.index ~= ent.index then
        pipeline:add(0, function ()
          target.onActivate(ent, n)
          system.call("main:targetEntityTriggered", pos, n)
        end)
      end
    end
  end
end)