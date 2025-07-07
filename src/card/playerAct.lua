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

system.on("@update", function ()
  local mouse = system.getStorage("realMouse")
  local uiEnt = player.cardUIselected
  if uiEnt then
    local flux = system.getStorage("flux")
    -- uiEnt.x = mouse.x-uiEnt.width/2
    -- uiEnt.y = mouse.y-uiEnt.height/2
    uiEnt.tween = flux.to(uiEnt, 0.2, { x = mouse.x-uiEnt.width/2, y = mouse.y-uiEnt.height/2})
    uiEnt.renderLayer = 100
  end
end)

system.on("main:cardReleased", function (ent)
  main.card.updateAllCardPositionBackToOriginalPosition()
end)

system.on("main:cardClicked", function (card)
  local cardUI = card.cardUI
  local currentCard = player.cardUIselected
  if currentCard then
    if currentCard.index == cardUI.index then
      if currentCard.onReleased then
        currentCard.onReleased(currentCard)
      end
    end

    player.cardUIselected = nil
  else

    if cardUI.tween then
      cardUI.tween:stop()
    end

    player.cardUIselected = cardUI
  end
end)

-- different situation from up, so i will be repeating this code
system.on("noUIClicked", function ()
  local currentCard = player.cardUIselected
  if currentCard then
    player.cardUIselected = nil

    if currentCard.onReleased then
      currentCard.onReleased(currentCard)
    end

  end
end)