local stacks = {"hand", "shop", "reward"}

system.on("@draw", function ()
  for i, stack in ipairs(stacks) do
    for i, card in ipairs(main.card[stack]) do
      local ui = card.ui
      local amount = card.repeatActivation
      if amount > 0 then
        local x=ui:getX()
        local y=ui:getY()
        local t=main.printRichText({
          format = amount .. "X",
          outline = true,
          outlineColor = {0.1, 0.1, 0.1},
          x=x+ui:getWidth(),
          y=y,
          renderLayer = ui.renderLayer+1,
        })
        t.x = t.x - t.richText:getWidth()/2
        t.y = t.y - t.richText:getHeight()/2
      end
    end
  end
end)