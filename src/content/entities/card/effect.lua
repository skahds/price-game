main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Card to the right gains {repeatColor}+1 REPEAT{/repeatColor}",
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",

  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    main.changeEntityComponent(target, "repeatActivation", 1, combiner.ADD)
  end
})

main.defineCard("magnifyingGlass", {
  name = "Magnifying Glass",
  image = "magnifyingGlass",
  energy = 2,
  description = "News in area gains {priceColor}+4 PRICE",
  trigger = {"DEPLOY"},
  price = 2,
  target = {
    shape = {w=3, h=3},
    onActivate = function (ent, targetEnt)
      main.changeEntityComponent(targetEnt, "defaultPriceGain", 5, combiner.ADD)
    end
  }
})

main.defineCard("void", {
  name = "Void",
  image = "void",
  energy = 0,
  description = "Destroy card to the right",
  trigger = {"DEPLOY"},
  temporary = 1,
  price = 2,
  rarity = "RARE",
  
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    main.tryDestroyEntity(target)
  end
})

main.defineCard("vision", {
  name = "Vision",
  image = "vision",
  defaultDrawCard = 2,
  trigger = {"DEPLOY"},
  price = 2,
  rarity = "RARE",
})

main.defineCard("quickOrb", {
  name = "Quick Orb",
  image = "quickOrb",
  description = "Gives {energyColor}+1 ENERGY",
  energy = 0,
  temporary = 3,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.addEnergy(1)
  end
})

main.defineCard("sacrifice", {
  name = "Sacrifice",
  image = "sacrifice",
  description = "Discard cards in hand",
  energy = 1,
  defaultDrawCard = 4,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.discardCurrentCardsInHand()
  end
})

main.defineCard("advancer", {
  name = "Advancer",
  isRelic = true,
  isHollow = true,
  image = "advancer",
  energy = 2,
  description = "Card to the right gains {multColor}+2 MULT",
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)

    if target then
      main.changeEntityComponent(target, "defaultMultGain", 2, combiner.ADD)
    end
  end
})

main.defineCard("retribution", {
  name = "Retribution",
  image = "retribution",
  isRelic = true,
  isHollow = true,
  description = "Destroys card to the right and\ngain 2x its PRICE as {priceColor}PRICE",
  energy = 2,
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local leftCard = main.getCardBesides(ent, 1)

    if leftCard then
      local price = leftCard.price
      local success = main.tryDestroyEntity(leftCard)
      if success then
        main.changeEntityComponent(ent, "defaultPriceGain", price*2, combiner.ADD)
      end
    end
  end
})
