main.defineCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"ROUND"},
  defaultPointGain = 6,
  price = 1,
})

main.defineCard("multiply", {
  name = "Multiply",
  image = "basicMultiply",
  trigger = {"ROUND"},
  defaultMultGain = 2,
  price = 1,
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"ROUND"},
  defaultPointGain = -6,
  price = 1,
})

main.defineCard("goldenHex", {
  name = "Golden Hex",
  image = "goldenHex",
  trigger = {"ROUND"},
  defaultMoneyGain = 1,
  rarity="RARE",
  price = 4,
})

main.defineCard("grassBow", {
  name = "Grass Bow",
  image = "grassBow",
  description = "Card to the right gains {pointColor}+3 points",
  trigger = {"ROUND"},
  onActivate = function (ent)
    local targetEnt = main.getCardBesides(ent, 1)
    if targetEnt then
      main.changeEntityComponent(targetEnt, "defaultPointGain", 3, combiner.ADD)
    end
  end,
  price = 2,
})

main.defineCard("junk", {
  name = "Junk",
  image = "junk",
  trigger = {"ROUND"},
  price = -1,
})