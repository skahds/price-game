main.defineCard("add", {
  name = "Add",
  image = "basicAdd",
  trigger = {"POST"},
  defaultPointGain = 5,
  price = 2,
})

main.defineCard("multiply", {
  name = "Multiply",
  image = "basicMultiply",
  trigger = {"POST"},
  defaultMultGain = 1,
  price = 2,
})

main.defineCard("subtract", {
  name = "Subtract",
  image = "basicSubtract",
  trigger = {"POST"},
  defaultPointGain = -5,
  price = 2,
})

main.defineCard("goldenHex", {
  name = "Golden Hex",
  image = "goldenHex",
  trigger = {"POST"},
  defaultMoneyGain = 1,
  price = 2,
})


main.defineCard("volatilityCard", {
  name = "volatility Card",
  image = "volatilityCard",
  trigger = {"DEPLOY"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    if chart then
      chart.volatility = chart.volatility + 0.2
    end
  end,
  price = 1,
})