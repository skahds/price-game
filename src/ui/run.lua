local function clickTop(button, uiFun)
  -- for making sure that *only* the top gets clicked
  local UIlist = {}
  local UIkey = 0

  local hasClicked = false
  for _, ent in pairs(main.ui.world) do
    local mouse
    if ent.screenSpace then
      mouse = system.getStorage("realMouse")
    else
      mouse = system.getStorage("mouse")
    end
    if main.AABB_check(ent, mouse) then
      if ent[uiFun] then
        if UIlist[ent.renderLayer] == nil then
          UIlist[ent.renderLayer] = {}
        end
        if UIkey < ent.renderLayer then
          UIkey = ent.renderLayer
        end
        table.insert(UIlist[ent.renderLayer], ent)
      end
      hasClicked = true
    end
  end

  local layer = UIlist[UIkey]
  if layer then
    for _, ent in pairs(layer) do
      ent[uiFun](ent, button)
    end
  end

  if hasClicked == false then
    system.call("ui:noUIClicked", button)
  end
end

system.on("@mouse:pressed", function (button)
  clickTop(button, "onMouseClicked")
end)

system.on("@mouse:released", function (button)
  clickTop(button, "onMouseReleased")
end)

system.on("@update", function ()
  -- for hover. so only the top gets called
  local UIlist = {}
  local UIkey = 0

  for _, ent in pairs(main.ui.world) do
    if ent.update then
      ent:update()
    end
    local mouse
    if ent.screenSpace then
      mouse = system.getStorage("realMouse")
    else
      mouse = system.getStorage("mouse")
    end
    if main.AABB_check(mouse, ent) then
      UIlist[ent.renderLayer] = {}
      if UIkey < ent.renderLayer then
        UIkey = ent.renderLayer
      end
      table.insert(UIlist[ent.renderLayer], ent)
    else
      -- for notHovered
      if ent.notHovered then
        ent:notHovered()
      end
    end
  end

  local layer = UIlist[UIkey]
  if layer then
    for _, ent in pairs(layer) do
      system.call("ui:UIHovered", ent)
      if ent.onHover then
        ent:onHover()
      end
    end
  else
    system.call("ui:noUIHovered")
  end



  
  for i=#main.ui.deleteQueue, 1, -1 do
    local ent = main.ui.deleteQueue[i]
    system.call("ui:entityDeleted", ent)
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
      system.call("ui:entityDrawn", ent)
    end
  end
end)