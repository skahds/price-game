-- for storing stuff that'll be used in this card folder, not for use outside
main.card = {
  -- the cards we own.. the index defines the order
  hand = {},
  -- to be used in the shop scene
  shop = {},
  -- the pile to draw
  draw = {},
  -- the pile after a card is used
  discard = {},
}

function main.createCard(id, args, ownerShip)
  ownerShip = ownerShip or "hand"
  local card = main.spawnEntity(id, args, true)
  table.insert(main.card[ownerShip], card)
  card.cardOrder = #main.card.hand
  card.ownerShip = ownerShip
  if card.ownerShip == "draw" or card.ownerShip == "discard" then
    card.ui.isVisible = false
  end
  return card
end

function main.deleteCard(card)
  if card.isAboutToBeDeleted == true then
    return
  end

  local cardOrder = card.cardOrder
  local cardUI = card.ui
  
  local stack = main.card[card.ownerShip]
  table.remove(stack, cardOrder)

  cardUI:delete()
  card:delete()
  
  main.card.updateAllCardPositionBackToOriginalPosition()
end

function main.getCardInOrder(order)
  local card = main.card.hand[order]
  if card then
    return card
  end
end

function main.defineCard(id, eType)
  -- card ent isn't shown, it will create its own UI ent
  -- card ent
  eType.id = id
  main.entities[id] = class(main.entities.basicEnt)
  local card = main.entities[id]
  local basicEnt = main.entities.basicEnt

  function card:init(args)
    basicEnt.init(self, args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    self.isCard = true

    local image = self.image or "blank_card"
    
    self.ui = main.ui.spawnUI("card_ui", {image=image, x=self.x, y=self.y}, true)
    self.ui.parent = self
  end

  function card:draw(args)

  end

  local rarityClass = system.getStorage("rarity:rarityClass")
  if rarityClass then
    rarityClass:new(eType)
  end
end

local function repeatingTriggerCard(card, trigger)
  local pipeline = main.getPipeline("main")
  local finished = false
  if main.canTrigger(card, trigger) then

    pipeline:add(0.3, function ()
      main.triggerEnt(card, trigger)

      local nextCard = main.card.hand[card.cardOrder + 1]
      if nextCard then
        repeatingTriggerCard(nextCard, trigger)
      else
        system.call("main:repeatingTriggerCardEnd", trigger)
      end

    end)
  else
    local nextCard = main.card.hand[card.cardOrder + 1]
    if nextCard then
      repeatingTriggerCard(nextCard, trigger)
    else
      system.call("main:repeatingTriggerCardEnd", trigger)
    end
  end
end

function main.triggerAllCardOwned(trigger)
  if #main.card.hand < 1 then
    system.call("main:repeatingTriggerCardEnd", trigger)
    return
  end
  local card = main.card.hand[1]
  repeatingTriggerCard(card, trigger)
end

local function orderBasedOnPosition(ownerShip)
  --reorder them based on their x position
  table.sort(main.card[ownerShip], function (a, b)
    local uiEnt1, uiEnt2 = a.ui, b.ui
    return uiEnt1.x < uiEnt2.x
  end)
  for i, card in ipairs(main.card[ownerShip]) do
    card.cardOrder = i
    card.ui.renderLayer = 140+i
  end
end

-- warning: does not update the cardOrder of the transfered card
function main.transferOwnership(card, newOwnership)
  if card.ownerShip == nil or card.ownerShip == newOwnership then
    return
  end
  local currentCardOwnership = card.ownerShip
  local cardOrder = card.cardOrder
  
  table.remove(main.card[currentCardOwnership], cardOrder)
  table.insert(main.card[newOwnership], card)
  card.ownerShip = newOwnership
  
  orderBasedOnPosition(currentCardOwnership)
  orderBasedOnPosition(newOwnership)

  system.call("main:cardTransferedOwnership", card, currentCardOwnership, newOwnership)
end

function main.discardCard(card)
  if card.ownerShip ~= "hand" then
    error("card ownerShip needs to be hand, not " .. card.ownerShip)
  end
  main.transferOwnership(card, "discard")
  local dimension = system.getStorage("screenDimension")
  local targetX, targetY = -200, dimension.h
  local flux = system.getStorage("flux")
  local ui = card.ui
  if ui.tween then
    ui.tween:stop()
  end
  ui.tween = flux.to(ui, 0.3, { x = targetX, y = targetY })
  main.wait(0.3, function ()
    ui.isVisible = false
  end)
  main.card.updateAllCardPositionBackToOriginalPosition("hand")
end

function main.drawCard()
  local card = main.card.draw[1]
  if card == nil then
    main.shuffleDiscardToDraw()
    main.drawCard()
    return
  end

  main.transferOwnership(card, "hand")
  local ui = card.ui
  ui.isVisible = true
  main.card.updateAllCardPositionBackToOriginalPosition("hand")
end

function main.drawCardWithMaxCapacity()
  local maxCard = system.getStorage("main:maxCardAmount")
  -- later we'll add a qbus to get how much space a card takes up
  if #main.card.hand < maxCard then
    main.drawCard()
  end
end

function main.drawCardTillMaxCapacity()
  local pipeline = main.getPipeline("main")
  local maxCard = system.getStorage("main:maxCardAmount")
  if #main.card.hand < maxCard and #main.card.draw + #main.card.discard > 0 then
    -- later we'll add a qbus to get how much space a card takes up
    main.drawCard()
    pipeline:add(0.15, function ()
      main.drawCardTillMaxCapacity()
    end)
  end
end

function main.addCardToDraw(card)
  main.transferOwnership(card, "draw")

  local dimension = system.getStorage("screenDimension")
  local targetX, targetY = dimension.w+20, dimension.h
  local flux = system.getStorage("flux")
  local ui = card.ui
  if ui.tween then
    ui.tween:stop()
  end
  ui.tween = flux.to(ui, 0.3, { x = targetX, y = targetY })
  main.wait(0.3, function ()
    ui.isVisible = false
  end)
end

function main.shuffleDiscardToDraw()

  for i=#main.card.discard, 1, -1 do
    local card = main.card.discard[i]
    main.transferOwnership(card, "draw")
  end

  utils.shuffle(main.card.draw)
  -- fix the order since it got shuffled
  for i, card in ipairs(main.card.draw) do
    card.cardOrder = i

    local dimension = system.getStorage("screenDimension")
    if card.ui.tween then
      card.ui.tween:stop()
    end
    local targetX, targetY = dimension.w+20, dimension.h
    card.ui.x, card.ui.y = targetX, targetY
  end
end

function main.discardCurrentCardsInHand()
  local pipeline = main.getPipeline("main")
  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    if not system.ask("main:shouldCardNotBeDiscared", combiner.OR, card) then
      pipeline:insert(0.15, 1, function ()
        main.discardCard(card)
      end)
    end
  end
end

--card-in folder functions

--cards are put in the middle of the screen, then extend per card
function main.card.updateAllCardPositionBackToOriginalPosition(ownerShip, pos)
  ownerShip = ownerShip or "hand"
  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  local pos = pos or {}
  local middleY = pos.y or screenH - 80
  local middleX = pos.x or screenW/2

  orderBasedOnPosition(ownerShip)
  
  for i, card in pairs(main.card[ownerShip]) do
    local uiEnt = card.ui
    local flux = system.getStorage("flux")

    local cardWidth, cardHeight = uiEnt:getWidth(), uiEnt:getHeight()
    
    local spaceBetweenCard = 500/(#main.card[ownerShip]/2+1)
    local orderOffset = (card.cardOrder-1)*spaceBetweenCard
    local leftOffset = -(#main.card[ownerShip]-1)*(spaceBetweenCard/2)
    local originalX = middleX - cardWidth/2

    local finalX = originalX + orderOffset + leftOffset
    local finalY = middleY - cardHeight/2

    if uiEnt.tween then
      uiEnt.tween:stop()
    end
    uiEnt.tween = flux.to(uiEnt, 0.3, { x = finalX, y = finalY })
  end
end