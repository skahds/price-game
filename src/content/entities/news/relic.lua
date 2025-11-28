main.defineNews("discount", {
  name = "Discount",
  image = "discountNews",
  trigger = {"EACHTURN"},
  description = "A random card becomes {energyColor}FREE{/energyColor}",
  isRelic = true,
  onActivate = function (ent)
    local r = love.math.random(1, #main.card.hand)
    local card = main.getCardInOrder(r)
    if card.overrideEnergy > 0 then
      card.overrideEnergy = 0
    end
  end,
  rarity = "RARE"
})

main.defineNews("dream", {
  name = "Dream",
  image = "dreamNews",
  trigger = {"EACHTURN"},
  isRelic = true,
  defaultDrawCard = 1,
  rarity = "COMMON"
})

main.defineNews("refine", {
  name = "Refine",
  image = "refineNews",
  trigger = {"EACHTURN"},
  description = "Your leftmost card\ngains {repeatColor}+1 REPEAT",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(1)
    main.changeEntityComponent(card, "repeatActivation", 1, combiner.ADD)
  end,
  rarity = "COMMON"
})

main.defineNews("nuclear", {
  name = "Nuclear",
  image = "nuclearNews",
  trigger = {"EACHTURN"},
  description = "Your rightmost card\ngains {repeatColor}+2 REPEAT\nand costs {energyColor}+1 ENERGY",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(-1)
    main.changeEntityComponent(card, "repeatActivation", 2, combiner.ADD)
    card.overrideEnergy = card.overrideEnergy + 1
  end,
  rarity = "RARE"
})

main.defineNews("burnoff", {
  name = "Burn Off",
  image = "burnOffNews",
  trigger = {"EACHTURN"},
  description = "Make a random card cost {energyColor}+1 ENERGY{/energyColor}",
  defaultEnergyGain = 1,
  isRelic = true,
  onActivate = function (ent)
    local r = love.math.random(1, #main.card.hand)
    local card = main.getCardInOrder(r)
    card.overrideEnergy = card.overrideEnergy + 1
  end,
  rarity = "RARE"
})

main.defineNews("focus", {
  name = "Focus",
  image = "focusNews",
  trigger = {"EACHTURN"},
  description = "Discard a random card",
  defaultEnergyGain = 1,
  isRelic = true,
  onActivate = function (ent)
    local r = love.math.random(1, #main.card.hand)
    local card = main.getCardInOrder(r)
    main.discardCard(card)
  end,
  rarity = "RARE"
})