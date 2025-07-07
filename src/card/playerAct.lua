local player = {}

-- system.on("@update", function (t)
--   -- local dx, dy = t.dx, t.dy
--   local mouse = system.getStorage("realMouse")
--   local uiEnt = player.cardUIselected
--   if uiEnt then
--     local flux = system.getStorage("flux")
--     local targX = mouse.x-uiEnt.width/2
--     local targY = mouse.y-uiEnt.height/2 
--     uiEnt.tween = flux.to(uiEnt, 3, { x = targX, y = targY})
--     print("fluxDup")
--     -- uiEnt.x = targX
--     -- uiEnt.y = targY
--   end
-- end)

system.on("@mouse:moved", function (t)
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

system.on("main:cardReleased", function (ent)
  print("released")
  main.card.updateAllCardPositionBackToOriginalPosition()
end)

system.on("main:cardClicked", function (card)
  local cardUI = card.cardUI
  local currentCard = player.cardUIselected
  if currentCard then
    print("thisGot")
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
    print("h")
  end
end)

-- different situation from up, so i will be repeating this code
-- system.on("noUIClicked", function ()
--   local currentCard = player.cardUIselected
--   if currentCard then
--     player.cardUIselected = nil

--     if currentCard.tween then
--       currentCard.tween:stop()
--     end

--     if currentCard.onReleased then
--       currentCard.onReleased(currentCard)
--     end

--   end
-- end)