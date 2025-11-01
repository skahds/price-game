-- for storing stuff that'll be used in this card folder, not for use outside
main.card = {
  -- the cards we own.. the index defines the order
  hand = {},
  -- the pile to draw
  draw = {},
  -- the pile after a card is used
  discard = {},
  -- to be used in the shop scene
  shop = {},
  -- to be used in the levelEnd
  reward = {},
}

local function fixCardOrderOnStack(ownerShip)
  local stack = main.card[ownerShip]
  for i, card in ipairs(stack) do
    card.cardOrder = i
  end
end

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

function main.createCardBesidesEntInHand(id, args, ent, positionOffset)
  local ownerShip = "hand"
  local positionOffset = positionOffset or 1
  local finalX = ent.ui.x + positionOffset
  local card = main.spawnEntity(id, args, true)
  card.ui.x = finalX
  card.ui.y = ent.ui.y
  table.insert(main.card[ownerShip], card)
  card.cardOrder = #main.card.hand
  card.ownerShip = ownerShip
  fixCardOrderOnStack(ownerShip)
  main.card.updateAllCardPositionBackToOriginalPosition()
  return card
end

-- helperish function, this was made during creation of content
function main.basicSpawnCard(id, args, ent, ownership)
  args.x, args.y = args.x or ent.y, args.y or ent.y
  if ownership == "hand" then
    return main.createCardBesidesEntInHand(id, args, ent)
  end

  if ownership == "draw" then
    local card = main.createCard(id, args, "draw")
    main.addCardToDraw(card)
    return card
  end

  if ownership == "discard" then
    local card = main.createCard(id, args, "discard")
    main.discardCard(card)
    return card
  end
end

function main.deleteCard(card)
  if card.isAboutToBeDeleted == true then
    return
  end

  local cardOrder = card.cardOrder
  local cardUI = card.ui
  
  local stack = main.card[card.ownerShip]
  table.remove(stack, cardOrder)
  fixCardOrderOnStack(card.ownerShip)

  cardUI:delete()
  card:delete()
  
  main.card.updateAllCardPositionBackToOriginalPosition()

  return true
end

function main.getCardInOrder(order)
  if order < 0 then
    order = #main.card.hand+order+1
  end
  local card = main.card.hand[order]
  if card then
    return card
  end
end

function main.getCardBesides(ent, cardOrder)
  return main.getCardInOrder(ent.cardOrder+cardOrder)
end

function main.defineCard(id, eType)
  -- card ent isn't shown, it will create its own UI ent
  -- card ent
  eType.id = id
  eType.isCard = true
  main.entities[id] = class(main.entities.basicEnt)
  local card = main.entities[id]
  local basicEnt = main.entities.basicEnt

  function card:init(args)
    basicEnt.init(self, args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    local image = self.image or "blank_card"
    
    self.ui = main.ui.spawnUI("card_ui", {image=image, x=self.x, y=self.y}, true)
    self.ui.parent = self

    self.energy = self.energy or 1
    self.overrideEnergy = self.overrideEnergy or self.energy
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

  if main.canTrigger(card, trigger) then
    pipeline:add(0.5, function ()
      main.triggerEnt(card, trigger)

      pipeline:add(0, function ()
        local nextCard
        if card.isAboutToBeDeleted ~= true then
          nextCard = main.getCardBesides(card, 1)
        else
          nextCard = main.getCardBesides(card, 0)
        end

        if nextCard then
          repeatingTriggerCard(nextCard, trigger)
        else
          system.call("main:repeatingTriggerCardEnd", trigger)
        end
      end)
      
    end)
  else
    local nextCard = main.getCardBesides(card, 1)
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
  local stack = main.card[ownerShip]

  --reorder them based on their x position
  table.sort(stack, function (a, b)
    local uiEnt1, uiEnt2 = a.ui, b.ui
    return uiEnt1.x < uiEnt2.x
  end)
  for i, card in ipairs(stack) do
    card.cardOrder = i
    card.ui.renderLayer = 140+i
  end
end

function main.transferOwnership(card, newOwnership)
  if card.ownerShip == nil or card.ownerShip == newOwnership then
    return
  end
  local currentCardOwnership = card.ownerShip
  local cardOrder = card.cardOrder
  
  table.remove(main.card[currentCardOwnership], cardOrder)
  table.insert(main.card[newOwnership], card)
  card.ownerShip = newOwnership
  
  fixCardOrderOnStack(currentCardOwnership)
  fixCardOrderOnStack(newOwnership)

  -- orderBasedOnPosition(currentCardOwnership)
  -- orderBasedOnPosition(newOwnership)

  system.call("main:cardTransferedOwnership", card, currentCardOwnership, newOwnership)
end

function main.cardToHand(card)
  main.transferOwnership(card, "hand")
  local ui = card.ui
  ui.isVisible = true
  main.card.updateAllCardPositionBackToOriginalPosition("hand")
end

function main.drawCard()
  local card = main.card.draw[1]
  if card == nil then
    return
  end

  main.transferOwnership(card, "hand")
  local ui = card.ui
  ui.isVisible = true
  main.card.updateAllCardPositionBackToOriginalPosition("hand")
end

function main.getCurrentCardInHandAmount()
  local space = 0
  for i, card in ipairs(main.card.hand) do
    space = space + system.ask("main:cardSpaceUsed", combiner.ADD, card)
  end
  return space
end

function main.getNextCard()
  local card = main.card.draw[1]
  if card == nil then
    main.shuffleDiscardToDraw()
    local card = main.card.draw[1]
    if card == nil then
      return
    end
    return card
  end
  return card
end

function main.drawCardWithMaxCapacity()
  local pipeline = main.getPipeline("main")
  local maxCard = system.getStorage("main:maxCardAmount")
  local nextCard = main.getNextCard()
  if nextCard then
    local currentSpace = main.getCurrentCardInHandAmount()
    local space = system.ask("main:cardSpaceUsed", combiner.ADD, nextCard)
    if currentSpace + space <= maxCard then
      pipeline:add(0, function ()
        main.drawCard()
      end)
    end
  end
end

system.answer("main:cardSpaceUsed", function ()
  return 1
end)

function main.drawCardTillMaxCapacity()
  local pipeline = main.getPipeline("main")
  local maxCard = system.getStorage("main:maxCardAmount")
  local nextCard = main.getNextCard()
  if nextCard then
    local currentSpace = main.getCurrentCardInHandAmount()
    local newCardSpace = system.ask("main:cardSpaceUsed", combiner.ADD, nextCard)
    if currentSpace + newCardSpace <= maxCard then
      pipeline:add(0, function ()
        if #main.card.draw == 0 and #main.card.discard > 0 then
          main.shuffleDiscardToDraw()
        end
        main.drawCard()
        pipeline:add(0.25, function ()
          main.drawCardTillMaxCapacity()
        end)
      end)
    else
      main.triggerAllNews("EACHTURN")
    end
  end
end

function main.discardCard(card)
  main.transferOwnership(card, "discard")
  local dimension = system.getStorage("screenDimension")
  local targetX, targetY = card.ui.x, dimension.h+100
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

function main.shuffleDraw()
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

function main.shuffleDiscardToDraw()

  for i=#main.card.discard, 1, -1 do
    local card = main.card.discard[i]
    main.transferOwnership(card, "draw")
  end

  main.shuffleDraw()
end

function main.discardCurrentCardsInHand()
  local pipeline = main.getPipeline("main")
  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    if not system.ask("main:shouldCardNotBeDiscared", combiner.OR, card) then
      pipeline:insert(0.25, 1, function ()
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
  local middleY = pos.y or screenH - 60
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