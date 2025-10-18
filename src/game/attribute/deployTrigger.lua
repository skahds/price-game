main.defineComponent("isLocked", false)

local cancelSize = 200

system.on("main:cardUIReleased", function (uiEnt, button)
  local ent = uiEnt.parent

  if ent.ownerShip == "shop" then
    return
  end

  if ent.isLocked then
    return
  end

  if main.canTrigger(ent, "DEPLOY") and button == 1 then
    local dimension = system.getStorage("screenDimension")
    local y = dimension.h-cancelSize
    if uiEnt:getWidth() + uiEnt.y > y then
      return
    end

    local pipline = main.getPipeline("main")
    local success = false
    pipline:add(0, function ()
      success = main.triggerEnt(ent, "DEPLOY")
    end)
    pipline:add(0, function ()
      if success then
        main.discardCard(ent)
      end
    end)
  end
end)

system.on("@draw", function ()
  local card = system.getStorage("main:currentSelectedCard")
  local realMouse = system.getStorage("realMouse")
  local mouse = system.getStorage("mouse")

  if card == nil then
    return
  end
  
  if card.ownerShip == "shop" then
    return
  end

  if card.isLocked then
    return
  end

  if card.mouseHeldArea then
    local area = card.mouseHeldArea.size
    local fixed = card.mouseHeldArea.fixed
    local pos
    if fixed then
      pos = realMouse
    else
      pos = mouse
    end
    system.render(301, function ()
      love.graphics.setColor(0.4, 0.7, 0.4, 0.5)
      love.graphics.rectangle("fill", pos.x-area/2, pos.y-area/2, area, area)
      love.graphics.setColor(0.5, 0.8, 0.5, 1)
      love.graphics.setLineWidth(5)
      love.graphics.rectangle("line", pos.x-area/2, pos.y-area/2, area, area)
    end, fixed)
  end

  if main.canTrigger(card, "DEPLOY") then
    system.render(290, function ()
      local dimension = system.getStorage("screenDimension")
      local y = dimension.h-cancelSize

      love.graphics.setColor(0.8, 0.5, 0.5, 0.4)
      love.graphics.rectangle("fill", 0, y, dimension.w, 500)

      love.graphics.setColor(0.9, 0.6, 0.6, 1)
      love.graphics.setLineWidth(10)
      love.graphics.line(0, y, 2000, y)

      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(system.getImage("mouseRight"), dimension.w-150, dimension.h-cancelSize+60)
    end, true)
  end
end)