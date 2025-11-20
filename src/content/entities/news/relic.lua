main.defineNews("discount", {
  name = "Discount",
  image = "discountNews",
  trigger = {"EACHTURN"},
  description = "A random card becomes free",
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
  image = "discountNews",
  trigger = {"EACHTURN"},
  isRelic = true,
  defaultDrawCard = 1,
  rarity = "COMMON"
})

main.defineNews("refine", {
  name = "Refine",
  image = "refineNews",
  trigger = {"EACHTURN"},
  description = "Your leftmost cards\ngains {repeatColor}+1 REPEAT",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(1)
    main.changeEntityComponent(card, "repeatActivation", 1, combiner.ADD)
  end,
  rarity = "RARE"
})

main.defineNews("nuclear", {
  name = "Nuclear",
  image = "nuclearNews",
  trigger = {"EACHTURN"},
  description = "Your rightmost cards\ngains {repeatColor}+2 REPEAT\nand cost {energyColor}+1 ENERGY",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(-1)
    main.changeEntityComponent(card, "repeatActivation", 2, combiner.ADD)
    card.overrideEnergy = card.overrideEnergy + 1
  end,
  rarity = "RARE"
})