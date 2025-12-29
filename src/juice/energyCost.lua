local font = system.getFont("defaultFont40")
local stacks = main.getAllVisiblePiles()

local function getGap(i)
  return (math.max(10, 35-i*3))*(i)
end

system.on("@draw", function ()
  for i, stack in ipairs(stacks) do
    for i, card in ipairs(stack) do
      local ui = card.ui
      local realAmount = card.overrideEnergy
      local oldAmount = card.energy
      local x=ui:getX()+5
      local y=ui:getY()+5
      system.render(ui.renderLayer+1, function ()
        local gap = 40
        for i=1, math.min(realAmount, oldAmount) do
          love.graphics.draw(system.getImage("energy"), x-16+getGap(i-1), y-16, 0, 2, 2)
        end
        if realAmount ~= oldAmount then
          if oldAmount > realAmount then
            for i=1, oldAmount-realAmount do
              love.graphics.setColor(1, 1, 1, 0.25)
              love.graphics.draw(system.getImage("energy"), x-16+getGap(i-1+realAmount), y-16, 0, 2, 2)
            end
          else
            for i=1, realAmount-oldAmount do
              love.graphics.setColor(1, 1, 1, 1)
              love.graphics.draw(system.getImage("energy2"), x-16+getGap(i-1+oldAmount), y-16, 0, 2, 2)
            end
          end
        end
      end, true)
    end
  end
end)