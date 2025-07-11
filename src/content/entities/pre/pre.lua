main.defineCard("testCard", {
  name = "add Card",
  image = "upCard",
  -- onReleased = function (ent)
  --   main.deleteCard(ent)
  --   local chart = system.getStorage("main:chart")
  --   if chart then
  --     chart.bullPower = chart.bullPower + 0.5
  --   end
  -- end
  trigger = {"POST"},
  onActivate = function (ent)
    local bar = system.getStorage("main:currentBar")
    bar:changePricePIP(0.1)
  end,
})

main.defineCard("volatilityCard", {
  name = "volatility Card",
  image = "volatilityCard",
  trigger = {"PRE"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    chart.volatility = chart.volatility + 0.2
  end,
})