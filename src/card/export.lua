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
    card.cardUI.renderLayer = 40+i
  end

  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  for i, card in pairs(main.card.ownedCards) do
    local uiEnt = card.cardUI
    local flux = system.getStorage("flux")

    local cardWidth, cardHeight = uiEnt.width, uiEnt.cardHeight
    
    local spaceBetweenCard = 200/(#main.card.ownedCards/2+1)
    local orderOffset = (card.cardOrder-1)*spaceBetweenCard
    local leftOffset = -(#main.card.ownedCards-1)*(spaceBetweenCard/2)
    local originalX = screenW/2 - cardWidth/2

    local finalX = originalX + orderOffset + leftOffset

    if uiEnt.tween then
      uiEnt.tween:stop()
    end
    uiEnt.tween = flux.to(uiEnt, 0.3, { x = finalX, y = 10 })
  end
end