system.on("@update", function ()
  local mousePosX, mousePosY = love.mouse.getPosition()
  system.updateStorage("realMouse", {x=mousePosX, y=mousePosY})
end)

system.on("@update", function ()
  for _, ent in pairs(main.world) do
    if ent.update then
      ent:update()
    end
  end

  for i=#main.deleteQueue, 1, -1 do
    local ent = main.deleteQueue[i]
    local entIndex = ent.index
    if ent.index ~= #main.world then
      local lastEnt = main.world[#main.world]
      main.world[entIndex] = lastEnt
      lastEnt.index = entIndex
    end

    table.remove(main.world, #main.world)
  end
  main.deleteQueue = {}
end)

system.on("@renderer:render", function ()
  for _, ent in pairs(main.world) do
    if ent.draw then
      ent:draw()
    end
  end
end)