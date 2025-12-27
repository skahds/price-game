main.defineComponent("isLocked", false)

local cancelSize = 150

system.on("main:cardUIReleased", function (uiEnt, button)
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

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
    local mouse = system.getStorage("realMouse")
    if main.AABB_check(mouse, ent.ui) or mouse.y > y then
      return
    end

    local pipline = main.getPipeline("main")
    local success = false
    local energy = (ent.overrideEnergy or ent.energy)
    pipline:add(0, function ()
      if system.getStorage("main:energy") >= energy then
        if main.canTriggerFullCheck(ent, "DEPLOY") then
          main.addEnergy(-energy)
        end

        success = main.triggerEnt(ent, "DEPLOY")
      end
    end)
    pipline:add(0, function ()
      if success then
        main.discardCard(ent)
        ent.overrideEnergy = ent.energy
      end
    end)
  end
end)

system.on("@draw", function ()
  local card = system.getStorage("main:currentSelectedCard")
  local realMouse = system.getStorage("realMouse")
  local mouse = system.getStorage("mouse")
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

  if card == nil then
    return
  end
  
  if card.ownerShip == "shop" then
    return
  end

  if card.isLocked then
    return
  end

  if main.canTrigger(card, "DEPLOY") then
    system.render(290, function ()
      local dimension = system.getStorage("screenDimension")
      local y = dimension.h - cancelSize

      love.graphics.setColor(0.8, 0.55, 0.5, 0.2)
      love.graphics.rectangle("fill", 0, y, dimension.w, 500)

      love.graphics.setColor(1, 0.6, 0.6, 0.7)
      love.graphics.setLineWidth(10)
      love.graphics.line(0, y, 2000, y)

      love.graphics.setColor(1, 1, 1)
      -- love.graphics.draw(system.getImage("mouseRight"), dimension.w-150, dimension.h-cancelSize+60)
    end, true)
  end
end)