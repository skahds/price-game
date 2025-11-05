main.definePlaceableNewsCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"DEPLOY"},
  price = 1,
}, {
  image = "upNews",
  trigger = {"ROUND"},
  defaultPriceGain = 6,
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"DEPLOY"},
  spawnNews="badNews",
  price = 1,
})

main.defineCard("multiply", {
  name = "Multiply",
  image = "basicMultiply",
  trigger = {"DEPLOY"},
  defaultMultGain = 2,
  price = 1,
})

main.defineCard("goldenHex", {
  name = "Golden Hex",
  image = "goldenHex",
  energy = 2,
  trigger = {"DEPLOY"},
  defaultMoneyGain = 1,
  rarity="RARE",
  price = 4,
})

main.defineCard("grassBow", {
  name = "Grass Bow",
  image = "grassBow",
  description = "Card to the right gains {priceColor}+3 PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local targetEnt = main.getCardBesides(ent, 1)
    if targetEnt then
      main.changeEntityComponent(targetEnt, "defaultPriceGain", 3, combiner.ADD)
    end
  end,
  price = 2,
})

main.defineCard("tail", {
  name = "Tail",
  image = "tail",
  description = "Gives half of {multColor}MULT{/multColor} as {priceColor}PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local mult = system.getStorage("main:mult")
    main.addPrice(math.floor(mult/2+0.5))
  end,
  price = 2,
})

main.defineCard("greenDice", {
  name = "Green Dice",
  image = "greenDice",
  description = "2/3 chance to give {priceColor}+10 PRICE{/priceColor}\n1/3 chance to give {priceColor}-10 PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    if love.math.random() > 1/3 then
      main.addPrice(10)
    else
      main.addPrice(-10)
    end
  end,
  price = 2,
})

main.defineCard("redDice", {
  name = "Red Dice",
  image = "redDice",
  description = "2/3 chance to give {priceColor}-10 PRICE{/priceColor}\n1/3 chance to give {priceColor}+10 PRICE",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    if love.math.random() > 1/3 then
      main.addPrice(-10)
    else
      main.addPrice(10)
    end
  end,
  price = 2,
})

main.defineCard("junk", {
  name = "Junk",
  image = "junk",
  trigger = {"DEPLOY"},
  temporary = 1,
  price = -1,
  rarity = "UNIQUE",
})