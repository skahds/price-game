system.on("@draw", function ()  
  for i, pile in ipairs(main.getAllVisiblePiles()) do
    for i, card in ipairs(pile) do
      local ui = card.ui
      if system.ask("main:isEntityDisabled", combiner.OR, card) == true then
        system.render(ui.renderLayer+1, function ()
          local x = system.ask("ui:getUIX", combiner.ADD, ui)
          local y = system.ask("ui:getUIY", combiner.ADD, ui)
          love.graphics.setColor(1, 1, 1, 0.6)
          love.graphics.draw(system.getImage("cardBlocked"), x, y, 0, ui.sx, ui.sy, ui.ox, ui.oy)
        end, true)
      end
    end
  end
end)