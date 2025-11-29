main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Card to the right\ngains {repeatColor}+1 REPEAT{/repeatColor}",
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

main.defineCard("whitewash", {
  name = "Whitewash",
  image = "whitewash",
  energy = 2,
  description = "News in area gains {priceColor}+4 PRICE",
  trigger = {"DEPLOY"},
  price = 2,
  target = {
    shape = {w=3, h=3},
    onActivate = function (ent, targetEnt)
      main.changeEntityComponent(targetEnt, "defaultPriceGain", 4, combiner.ADD)
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
  rarity="UNIQUE",
  
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

main.defineCard("reserve", {
  name = "Reserve",
  image = "reserve",
  defaultEnergyGain=1,
  energy = 0,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
})

main.defineCard("sigil", {
  name = "Sigil",
  image = "sigil",
  description = "Doubles current {energyColor}ENERGY",
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
})

main.defineCard("secondPlan", {
  name = "Second Plan",
  image = "secondPlan",
  description = "Discard all cards in hand",
  energy = 1,
  defaultDrawCard = 4,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.discardCurrentCardsInHand()
  end
})

main.defineCard("grant", {
  name = "Grant",
  image = "grant",
  energy = 2,
  description = "Card to the right gains {multColor}+3 MULT",
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)

    if target then
      main.changeEntityComponent(target, "defaultMultGain", 3, combiner.ADD)
    end
  end
})

main.defineCard("reap", {
  name = "Reap",
  image = "reap",
  description = "Destroys card to the right and\ngains its {priceColor}PRICE",
  energy = 2,
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local leftCard = main.getCardBesides(ent, 1)

    if leftCard then
      local price = leftCard.defaultPriceGain
      local success = main.tryDestroyEntity(leftCard)
      if success then
        main.changeEntityComponent(ent, "defaultPriceGain", price, combiner.ADD)
      end
    end
  end
})
