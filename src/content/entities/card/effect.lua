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
    if target then
      main.changeEntityComponent(target, "repeatActivation", 1, combiner.ADD)
    end
  end
})

main.defineCard("whitewash", {
  name = "Whitewash",
  image = "whitewash",
  energy = 0,
  description = "News in area gains {priceColor}+5 PRICE",
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
  rarity="UNIQUE",
  
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      main.tryDestroyEntity(target)
    end
  end
})

main.defineCard("vision", {
  name = "Vision",
  image = "vision",
  defaultDrawCard = 3,
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
  onActivate = function ()
    local energy = system.getStorage("main:energy")
    main.addEnergy(energy)
  end,
  rarity = "RARE",
})

main.defineCard("augment", {
  name = "Augment",
  image = "augment",
  description = "Spend all energy, Card to\nthe right gains that many {repeatColor}REPEAT{/repeatColor}",
  energy=0,
  trigger = {"DEPLOY"},
  price = 3,
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      local energy = system.getStorage("main:energy")
      main.addEnergy(-energy)
      main.changeEntityComponent(target, "repeatActivation", energy, combiner.ADD)
    end
  end,
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
  energy = 1,
  description = "Card to the right gains {multColor}+3 MULT",
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "RARE",

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
  energy = 1,
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

main.defineCard("doubleDown", {
  name = "Double down",
  image = "doubleDown",
  description = "Multiplies current {priceColor}PRICE{/priceColor} by 2",
  trigger = {"DEPLOY"},
  price = 3,
  rarity  = "RARE",
  onActivate = function (ent)
    local prices = main.getPrice()
    main.addPrice(prices)
  end
})

main.defineCard("fortune", {
  name = "Fortune",
  image = "fortune",
  description = "Multiplies current {priceColor}MULT{/priceColor} by 2",
  trigger = {"DEPLOY"},
  price = 3,
  rarity  = "RARE",
  onActivate = function (ent)
    local mult = system.getStorage("main:mult")
    main.addMult(mult)
  end
})

local function getStalemartyrPrice()
  local piles = {main.card.draw, main.card.discard, main.card.hand}
  local amount = 0
  for k, pile in ipairs(piles) do
    for i, card in ipairs(pile) do
      if card.defaultPriceGain then
        amount = amount + card.defaultPriceGain
      end
    end
  end
  return amount
end
main.defineCard("stalemartyr", {
  name = "Stalemartyr",
  image = "stalemartyr",
  description = "Gives {multColor}MULT{/multColor} equal to the sum\nof all {priceColor}PRICE{/priceColor} in the deck",
  trigger = {"DEPLOY"},
  price = 3,

  onUpdate = function (ent)
    local amount = getStalemartyrPrice()
    if amount > 0 then
      amount = "+" .. tostring(amount)
    end
    ent.description = "Gives {multColor}MULT{/multColor} equal to the sum\nof all {priceColor}PRICE{/priceColor} in the deck\n(currently {multColor}" .. amount .. " MULT{/multColor})"
  end,

  onActivate = function (ent)
    main.addPrice(getStalemartyrPrice())
  end
})

main.defineCard("lastHope", {
  name = "Last Hope",
  image = "lastHope",
  description = "Discard all cards in hand,\n draw 1 CARD and\ngive it {repeatColor}+3 REPEAT{/repeatColor}",
  energy = 1,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.discardCurrentCardsInHand()
    local card = main.drawCard()
    main.changeEntityComponent(card, "repeatActivation", 3, combiner.ADD)
  end
})

main.defineCard("relay", {
  name = "Relay",
  image = "relay",
  description = "Trigger card to the right",
  trigger = {"DEPLOY"},
  energy=0,
  price = 4,
  rarity = "EPIC",

  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      local pipeline = main.getPipeline("main")
      pipeline:add(0.5, function ()
        main.triggerEnt(target, "DEPLOY")
      end)
    end
  end
})

main.defineCard("spirit", {
  name = "Spirit",
  image = "spirit",
  description = "If there are fewer\nthan 3 cards in hand,",
  trigger = {"DEPLOY"},
  energy=0,
  price = 3,
  rarity = "RARE",
  defaultDrawCard=2,

  filter = function (ent)
    if #main.card.hand < 3 then
      return true
    end
  end,
})