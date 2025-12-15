local player = {}

system.on("@update", function ()
  local mouse = system.getStorage("realMouse")
  local uiEnt = player.cardUIselected
  if uiEnt then
    system.updateStorage("main:currentSelectedCard", uiEnt.parent)
    main.card.updateAllCardPositionBackToOriginalPosition("hand", {ignoreCard=uiEnt.parent})

    if uiEnt.parent.ownerShip == "shop" then
      return
    end
    
    local flux = system.getStorage("flux")
    uiEnt.tween = flux.to(uiEnt, 0.2, { x = mouse.x-uiEnt:getWidth()/2, y = math.max(mouse.y-uiEnt:getHeight()/2, 570)})
    uiEnt.renderLayer = math.max(300, uiEnt.renderLayer)
  else
    system.updateStorage("main:currentSelectedCard", nil)
  end
end)

system.on("main:cardUIReleased", function (uiEnt)
  uiEnt.color = {1, 1, 1, 1}
  main.card.updateAllCardPositionBackToOriginalPosition()
end)

local function releaseUICard(card, button)
  if card.onReleased then
    card.onReleased(card)
  end

  system.call("main:cardUIReleased", card, button)
end

system.on("main:cardClicked", function (card, button)
  local cardUI = card.ui
  local currentCard = player.cardUIselected

  if cardUI.ignoreCardSelect or card.ignoreCardSelect then
    return
  end

  if currentCard then
    releaseUICard(currentCard, button)

    -- see wether the card we chose is the same or different than the current held
    if currentCard.index == cardUI.index then
      player.cardUIselected = nil
    else
      player.cardUIselected = cardUI
    end
    
  -- select the card if we aren't currently selecting any
  else
    
    if system.getStorage("main:isOnTurn") == true then
      return
    end

    if cardUI.tween then
      cardUI.tween:stop()
    end

    player.cardUIselected = cardUI
  end
end)

-- different situation from up, so i will be repeating this code
system.on("ui:noUIClicked", function (button)
  local currentCard = player.cardUIselected
  if currentCard then

    player.cardUIselected = nil
    releaseUICard(currentCard, button)
  end
end)

system.on("ui:uiClicked", function (ui, button)
  local currentCard = player.cardUIselected
  if currentCard and currentCard.index ~= ui.index then

    player.cardUIselected = nil
    releaseUICard(currentCard, button)
  end
end)