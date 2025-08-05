local player = {}

system.on("@update", function ()
  local mouse = system.getStorage("realMouse")
  local uiEnt = player.cardUIselected
  if uiEnt then
    local flux = system.getStorage("flux")
    uiEnt.tween = flux.to(uiEnt, 0.2, { x = mouse.x-uiEnt.width/2, y = mouse.y-uiEnt.height/2})
    uiEnt.renderLayer = 300
  end
end)

system.on("main:cardReleased", function (ent)
  main.card.updateAllCardPositionBackToOriginalPosition()
end)

local function releaseUICard(card)
  if card.onReleased then
    card.onReleased(card)
  end

  system.call("main:cardReleased", card)
end

system.on("main:cardClicked", function (card)
  local cardUI = card.cardUI
  local currentCard = player.cardUIselected
  if currentCard then
    releaseUICard(currentCard)

    -- see wether the card we chose is the same or different than the current held
    if currentCard.index == cardUI.index then
      player.cardUIselected = nil
    else
      player.cardUIselected = cardUI
    end
    
  -- select the card if we aren't currently selecting any
  else

    if cardUI.tween then
      cardUI.tween:stop()
    end

    player.cardUIselected = cardUI
  end
end)

-- different situation from up, so i will be repeating this code
system.on("ui:noUIClicked", function ()
  local currentCard = player.cardUIselected
  if currentCard then

    player.cardUIselected = nil
    releaseUICard(currentCard)
  end
end)