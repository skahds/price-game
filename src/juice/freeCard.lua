local flux = system.getStorage("flux")

local info = {oppacity=0}

system.on("@draw", function ()
  if info.oppacity >= 0.79 then
    flux.to(info, 1, {oppacity=0.4})
  elseif info.oppacity <= 0.41 then
    flux.to(info, 1, {oppacity=0.8})
  end
  
  for i, pile in ipairs(main.getAllVisibleStack()) do
    for i, card in ipairs(pile) do
      local ui = card.ui
      if card.overrideEnergy == 0 then
        system.render(ui.renderLayer-1, function ()
          local size=6
          love.graphics.setColor(0.5, 1, 0.3, info.oppacity)
          love.graphics.rectangle("fill", ui:getX()-size, ui:getY()-size, ui:getWidth()+size*2, ui:getHeight()+size*2, 5, 5)
        end, true)
      end
    end
  end
end)