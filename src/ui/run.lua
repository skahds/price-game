system.on("@mouse:released", function (button)
  -- for making sure that *only* the top gets clicked
  local UIlist = {}
  local UIkey = 0

  local hasClicked = false
  for _, ent in pairs(main.ui.world) do
    local mouse
    if ent.cameraFixed then
      mouse = system.getStorage("realMouse")
    else
      mouse = system.getStorage("mouse")
    end
    if main.AABB_check(ent, mouse) then
      if ent.onClicked then
        UIlist[ent.renderLayer] = {}
        if UIkey < ent.renderLayer then
          UIkey = ent.renderLayer
        end
        table.insert(UIlist[ent.renderLayer], ent)

        hasClicked = true
      end
    end
  end

  local layer = UIlist[UIkey]
  if layer then
    for _, ent in pairs(layer) do
      ent.onClicked(ent, button)
    end
  end

  if hasClicked == false then
    system.call("noUIClicked", button)
  end
end)

system.on("@update", function ()
  for _, ent in pairs(main.ui.world) do
    if ent.update then
      ent:update()
    end
  end

  for i=#main.ui.deleteQueue, 1, -1 do
    local ent = main.ui.deleteQueue[i]
    local entIndex = ent.index

    if ent.index ~= #main.ui.world then
      local lastEnt = main.ui.world[#main.ui.world]
      main.ui.world[entIndex] = lastEnt
      lastEnt.index = entIndex
    end

    table.remove(main.ui.world, #main.ui.world)
  end
  main.ui.deleteQueue = {}
end)

system.on("@renderer:render", function ()
  for _, ent in pairs(main.ui.world) do
    if ent.draw then
      ent:draw()
    end
  end
end)