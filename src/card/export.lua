-- for storing stuff that'll be used in this card folder, not for use outside
main.card = {
  -- the cards we own.. the index defines the order
  ownedCards = {},
  shop = {}
}

function main.createCard(id, args, ownerShip)
  ownerShip = ownerShip or "ownedCards"
  local card = main.spawnEntity(id, args, true)
  table.insert(main.card[ownerShip], card)
  card.cardOrder = #main.card.ownedCards
  card.ownerShip = ownerShip
  return card
end

function main.deleteCard(card)
  local cardOrder = card.cardOrder
  local cardUI = card.ui
  
  table.remove(main.card[card.ownerShip], cardOrder)
  cardUI:delete()
  card:delete()

  main.card.updateAllCardPositionBackToOriginalPosition()
end

function main.getCardInOrder(order)
  local card = main.card.ownedCards[order]
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
  if main.canTrigger(card, trigger) then
    pipeline:insert(0.3, 1, function ()
      main.triggerEnt(card, trigger)

      local nextCard = main.card.ownedCards[card.cardOrder + 1]
      if nextCard then
        repeatingTriggerCard(nextCard, trigger)
      end
    end)
  else
    local nextCard = main.card.ownedCards[card.cardOrder + 1]
    if nextCard then
      repeatingTriggerCard(nextCard, trigger)
    end
  end
end

function main.triggerAllCardOwned(trigger)
  local pipeline = main.getPipeline("main")
  if #main.card.ownedCards < 1 then
    return
  end
  local card = main.card.ownedCards[1]
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

  system.call("main:cardTransferedOwnership", card, currentCardOwnership, newOwnership)
end

--card-in folder functions

--cards are put in the middle of the screen, then extend per card
function main.card.updateAllCardPositionBackToOriginalPosition(ownerShip, pos)
  ownerShip = ownerShip or "ownedCards"
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