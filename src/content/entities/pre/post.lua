main.defineCard("testCard", {
  name = "add Card",
  image = "upCard",
  description = "cool {pointColor}things{/pointColor}",
  trigger = {"POST", "DEPLOY"},
  defaultPointGain = 3,
  price = 2,
})

main.defineCard("testCardOther", {
  name = "mult Card",
  image = "upCard",
  description = "beep boop",
  trigger = {"POST"},
  defaultMultGain = 1,
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