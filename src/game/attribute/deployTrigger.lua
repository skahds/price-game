local cancelSize = 200

system.on("main:cardUIReleased", function (uiEnt, button)
  local ent = uiEnt.parent
  if main.canTrigger(ent, "DEPLOY") and button == 1 then
    local dimension = system.getStorage("screenDimension")
    local y = dimension.h-cancelSize
    if uiEnt:getWidth() + uiEnt.y > y then
      return
    end

    local pipline = main.getPipeline("main")
    pipline:add(0, function ()
      main.triggerEnt(ent, "DEPLOY")
    end)
    pipline:add(0, function ()
      main.discardCard(ent)
    end)
  end
end)

system.on("@draw", function ()
  local card = system.getStorage("main:currentSelectedCard")
  if card then
    if main.canTrigger(card, "DEPLOY") then
      system.render(290, function ()
        local dimension = system.getStorage("screenDimension")
        local y = dimension.h-cancelSize

        love.graphics.setColor(0.8, 0.5, 0.5, 0.4)
        love.graphics.rectangle("fill", 0, y, dimension.w, 500)

        love.graphics.setColor(0.9, 0.6, 0.6, 1)
        love.graphics.setLineWidth(10)
        love.graphics.line(0, y, 2000, y)
      end, true)
    end
  end
end)