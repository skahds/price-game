main.defineNews("goodNews", {
  name = "Up",
  image = "upNews",
  trigger = {"ROUND"},
  temporary = 3,
  defaultPriceGain=5,
})

main.defineNews("badNews", {
  name = "Down",
  image = "downNews",
  trigger = {"ROUND"},
  temporary = 3,
  defaultPriceGain=-5,
})

main.defineNews("volatileNews", {
  name = "Volatility",
  image = "volatileNews",
  description = "Make round-start price change bigger",
  trigger = {"ROUND"},
  temporary = 2,
  onActivate = function ()
    local chart = system.getStorage("main:chart")
    if chart then
      chart.volatility = math.max(0, chart.volatility + 0.1)
    end
  end
})

main.defineNews("calmNews", {
  name = "Calmness",
  image = "calmNews",
  description = "Make round-start price change smaller",
  trigger = {"ROUND"},
  temporary = 2,
  onActivate = function ()
    local chart = system.getStorage("main:chart")
    if chart then
      chart.volatility = math.max(0, chart.volatility - 0.1)
    end
  end
})