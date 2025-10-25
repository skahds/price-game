main.defineCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"DEPLOY"},
  defaultPointGain = 6,
  price = 1,
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"DEPLOY"},
  defaultPointGain = -6,
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
  description = "Card to the right gains {pointColor}+3 points",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local targetEnt = main.getCardBesides(ent, 1)
    if targetEnt then
      main.changeEntityComponent(targetEnt, "defaultPointGain", 3, combiner.ADD)
    end
  end,
  price = 2,
})

main.defineCard("tail", {
  name = "Tail",
  image = "tail",
  description = "Gives half of {multColor}mult{/multColor} as {pointColor}points",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local mult = system.getStorage("main:mult")
    main.addPoint(math.floor(mult/2+0.5))
  end,
  price = 2,
})

main.defineCard("greenDice", {
  name = "Green Dice",
  image = "greenDice",
  description = "2/3 chance to give {pointColor}+10 points{/pointColor}\n1/3 chance to give {pointColor}-10 points",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    if love.math.random() > 1/3 then
      main.addPoint(10)
    else
      main.addPoint(-10)
    end
  end,
  price = 2,
})

main.defineCard("redDice", {
  name = "Red Dice",
  image = "redDice",
  description = "2/3 chance to give {pointColor}-10 points{/pointColor}\n1/3 chance to give {pointColor}+10 points",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    if love.math.random() > 1/3 then
      main.addPoint(-10)
    else
      main.addPoint(10)
    end
  end,
  price = 2,
})

main.defineCard("junk", {
  name = "Junk",
  image = "junk",
  trigger = {"DEPLOY"},
  price = -1,
})