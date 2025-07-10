-- for storing stuff that'll be used in this card folder, not for use outside
main.card = {
  -- the cards we own.. the index defines the order
  ownedCards = {}
}

function main.createCard(id, args)
  local card = main.spawnEntity(id, args, true)
  table.insert(main.card.ownedCards, card)
  card.cardOrder = #main.card.ownedCards
  return card
end

function main.deleteCard(card)
  local cardOrder = card.cardOrder
  local cardUI = card.cardUI
  
  cardUI:delete()
  card:delete()
  table.remove(main.card.ownedCards, cardOrder)

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
    
    self.cardUI = main.ui.spawnUI("card_ui", {image=image, x=100, y=100}, true)
    self.cardUI.card = self
  end

  function card:draw(args)

  end
end

local function isEInTable(e, t)
  for k, v in pairs(t) do
    if v == e then
      return true
    end
  end
  return false
end

function main.canTrigger(ent, trigger)
  if ent and ent.trigger then
    if isEInTable(trigger, ent.trigger) == false then
      return false
    end

  end
  return true
end

function main.triggerEnt(ent, trigger)
  if main.canTrigger(ent, trigger) then
    if ent.onActivate then
      ent:onActivate()
    end
    
    system.call("main:entityTriggered", ent)
  end
  return true
end

function main.triggerAllCardOwned(trigger)
  local pipeline = main.getPipeline("main")
  for _, card in ipairs(main.card.ownedCards) do
    if main.canTrigger(card, trigger) then
      pipeline:add(0.3, function ()
        main.triggerEnt(card, trigger)
      end)
    end
  end
end

--card-in folder functions

--cards are put in the middle of the screen, then extend per card
function main.card.updateAllCardPositionBackToOriginalPosition()
  --reorder them based on their x position
  table.sort(main.card.ownedCards, function (a, b)
    local uiEnt1, uiEnt2 = a.cardUI, b.cardUI
    return uiEnt1.x < uiEnt2.x
  end)
  for i, card in ipairs(main.card.ownedCards) do
    card.cardOrder = i
    card.cardUI.renderLayer = 140+i
  end

  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  for i, card in pairs(main.card.ownedCards) do
    local uiEnt = card.cardUI
    local flux = system.getStorage("flux")

    local cardWidth, cardHeight = uiEnt.width, uiEnt.height
    
    local spaceBetweenCard = 500/(#main.card.ownedCards/2+1)
    local orderOffset = (card.cardOrder-1)*spaceBetweenCard
    local leftOffset = -(#main.card.ownedCards-1)*(spaceBetweenCard/2)
    local originalX = screenW/2 - cardWidth/2

    local finalX = originalX + orderOffset + leftOffset
    local finalY = screenH - cardHeight - 10

    if uiEnt.tween then
      uiEnt.tween:stop()
    end
    uiEnt.tween = flux.to(uiEnt, 0.3, { x = finalX, y = finalY })
  end
end