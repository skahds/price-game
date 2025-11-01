local font = system.getFont("defaultFont40")
local stacks = {"hand", "shop", "reward"}

system.on("@draw", function ()
  for i, stack in ipairs(stacks) do
    for i, card in ipairs(main.card[stack]) do
      local ui = card.ui
      local realAmount = card.overrideEnergy
      local oldAmount = card.energy
      local x=ui:getX()
      local y=ui:getY()
      system.render(299, function ()
        for i=1, realAmount do
          love.graphics.draw(system.getImage("energy"), x-16+40*(i-1), y-16, 0, 2, 2)
        end
        if realAmount ~= oldAmount then
          for i=1, oldAmount-realAmount do
            love.graphics.setColor(1, 1, 1, 0.5)
            love.graphics.draw(system.getImage("energy"), x-16+40*(i-1+realAmount), y-16, 0, 2, 2)
          end
        end
      end, true)
    end
  end
end)