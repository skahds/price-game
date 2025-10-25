local font = system.getFont("defaultFont40")

system.on("@draw", function ()
  for i, card in ipairs(main.card.hand) do
    local ui = card.ui
    if card.energy then
      local x=ui.x
      local y=ui.y
      system.render(299, function ()
        love.graphics.draw(system.getImage("energy"), x-16, y-16, 0, 2, 2)
      end, true)
    end
  end

  for i, card in ipairs(main.card.shop) do
    local ui = card.ui
    if card.energy then
      local x=ui.x
      local y=ui.y
      system.render(299, function ()
        love.graphics.draw(system.getImage("energy"), x-16, y-16, 0, 2, 2)
      end, true)
    end
  end
end)