main.defineCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"POST"},
  defaultPointGain = 6,
  price = 2,
})

main.defineCard("multiply", {
  name = "Multiply",
  image = "basicMultiply",
  trigger = {"POST"},
  defaultMultGain = 2,
  price = 2,
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"POST"},
  defaultPointGain = -6,
  price = 2,
})

main.defineCard("goldenHex", {
  name = "Golden Hex",
  image = "goldenHex",
  trigger = {"POST"},
  defaultMoneyGain = 1,
  price = 2,
})

main.defineCard("giver", {
  name = "Giver",
  image = "addRight",
  description = "Card to the right gains {pointColor}+3 points",
  trigger = {"POST"},
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
  trigger = {"POST"},
  price = -1,
})

-- main.defineCard("volatilityCard", {
--   name = "volatility Card",
--   image = "volatilityCard",
--   trigger = {"DEPLOY"},
--   onActivate = function (ent)
--     local chart = system.getStorage("main:chart")
--     if chart then
--       chart.volatility = chart.volatility + 0.2
--     end
--   end,
--   price = 1,
-- })