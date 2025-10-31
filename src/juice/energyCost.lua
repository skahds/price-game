local font = system.getFont("defaultFont40")
local stacks = {"hand", "shop", "reward"}

system.on("@draw", function ()
  for i, stack in ipairs(stacks) do
    for i, card in ipairs(main.card[stack]) do
      local ui = card.ui
      if card.energy then
        local x=ui.x
        local y=ui.y
        system.render(299, function ()
          for i=1, card.energy do
            love.graphics.draw(system.getImage("energy"), x-16+40*(i-1), y-16, 0, 2, 2)
          end
        end, true)
      end
    end
  end
end)