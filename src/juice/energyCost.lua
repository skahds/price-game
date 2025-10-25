local font = system.getFont("defaultFont40")

system.on("@draw", function ()
  for i, card in ipairs(main.card.hand) do
    local ui = card.ui
    local width, height = ui:getWidth(), ui:getHeight()
    if card.energy then
      local x=ui.x
      local y=ui.y
      -- local richText = main.printRichText({format=(card.energy),
      -- x=x,
      -- y=y,
      -- renderLayer = 300,
      -- font=font
      -- })
      -- local richTextWidth = richText.richText:getWidth()
      -- local richTextHeight = richText.richText:getHeight()
      -- richText.x = richText.x - richTextWidth/2
      -- richText.y = richText.y - richTextHeight/2

      system.render(299, function ()
        love.graphics.draw(system.getImage("energy"), x-16, y-16, 0, 2, 2)
      end, true)
    end
  end
end)