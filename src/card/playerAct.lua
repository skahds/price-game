local player = {}

system.on("mouse:moved", function (t)
  local dx, dy = t.dx, t.dy
  local mouse = system.getStorage("realMouse")
  local uiEnt = player.cardUIselected
  if uiEnt then
    uiEnt.x = uiEnt.x + dx
    uiEnt.y = uiEnt.y + dy
  end
end)
--[[
system.on("main:cardHovered", function (ent)
  if love.mouse.isDown(1) then
    player.cardUIselected = ent.cardUI
    
    if ent.cardUI.tween then
      ent.cardUI.tween:stop()
    end
  end
end)
]]

-- system.on("main:cardReleased", function (ent)
--   if player.cardUIselected then
--     player.cardUIselected = nil
--   end
-- end)

system.on("main:cardClicked", function (card)
  local cardUI = card.cardUI
  local currentCard = player.cardUIselected
  if currentCard then
    if currentCard.index == cardUI.index then
      
      if currentCard.onReleased then
        currentCard.onReleased(currentCard)
      end

      player.cardUIselected = nil
    end

  else

    if cardUI.tween then
      cardUI.tween:stop()
    end

    player.cardUIselected = cardUI
  end
end)