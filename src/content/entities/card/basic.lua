main.defineCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"DEPLOY"},
  defaultPriceGain = 10,
  price = 1,
  rarity="STARTER"
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"DEPLOY"},
  defaultPriceGain = -10,
  price = 1,
  rarity="STARTER"
})


main.defineCard("multiply", {
  name = "Multiply",
  image = "basicMultiply",
  trigger = {"DEPLOY"},
  defaultMultGain = 4,
  price = 1,
  rarity="STARTER"
})

-- main.defineCard("goldenHex", {
--   name = "Golden Hex",
--   image = "goldenHex",
--   energy = 2,
--   trigger = {"DEPLOY"},
--   defaultMoneyGain = 1,
--   rarity="RARE",
--   price = 4,
-- })

main.defineCard("grassBow", {
  name = "Grass Bow",
  image = "grassBow",
  description = "Card to the right gains {priceColor}+6 PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local targetEnt = main.getCardBesides(ent, 1)
    if targetEnt then
      main.changeEntityComponent(targetEnt, "defaultPriceGain", 6, combiner.ADD)
    end
  end,
  price = 2,
  rarity = "COMMON",
})

main.defineCard("wake", {
  name = "Wake",
  image = "wake",
  description = "Gains {priceColor}+5 PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    main.changeEntityComponent(ent, "defaultPriceGain", 5, combiner.ADD)
  end,
  price = 2,
  rarity = "COMMON",
})

main.defineCard("rebalance", {
  name = "Rebalance",
  image = "rebalance",
  description = "Gives {priceColor}PRICE{/priceColor} equal to {multColor}MULT{/multColor}",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local mult = system.getStorage("main:mult")
    main.addPrice(mult)
  end,
  price = 2,
  rarity = "COMMON",
})

main.defineCard("greenDice", {
  name = "Green Dice",
  image = "greenDice",
  description = "1 in 2 chance to give {priceColor}+30 PRICE{/priceColor}\nelse, give {multColor}+10 MULT",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    if love.math.random() > 1/2 then
      main.addPrice(30)
    else
      main.addMult(10)
    end
  end,
  price = 2,
  rarity = "COMMON",
})

main.defineCard("junk", {
  name = "Junk",
  image = "junk",
  trigger = {"DEPLOY"},
  temporary = 1,
  momentary = true,
  price = 0,
  rarity = "UNIQUE",
})