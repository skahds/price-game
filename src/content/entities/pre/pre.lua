main.defineCard("testCard", {
  name = "add Card",
  image = "upCard",
  description = "cool {pointColor}things{/pointColor}",
  -- onReleased = function (ent)
  --   main.deleteCard(ent)
  --   local chart = system.getStorage("main:chart")
  --   if chart then
  --     chart.bullPower = chart.bullPower + 0.5
  --   end
  -- end
  trigger = {"POST"},
  onActivate = function (ent)
    main.addPoint(3)
  end,
  price = 2,
})

main.defineCard("testCardOther", {
  name = "mult Card",
  image = "upCard",
  description = "+1 {brightPurpleColor}mult{/brightPurpleColor}",
  -- onReleased = function (ent)
  --   main.deleteCard(ent)
  --   local chart = system.getStorage("main:chart")
  --   if chart then
  --     chart.bullPower = chart.bullPower + 0.5
  --   end
  -- end
  trigger = {"POST"},
  onActivate = function (ent)
    main.addMult(1)
  end,
  price = 2,
})

main.defineCard("volatilityCard", {
  name = "volatility Card",
  image = "volatilityCard",
  trigger = {"PRE"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    chart.volatility = chart.volatility + 0.2
  end,
  price = 1,
})