main.defineNews("goodNews", {
  name = "Good thing",
  image = "upNews",
  trigger = {"POST"},
  temporary = 3,
  defaultPointGain=3,
})

main.defineNews("badNews", {
  name = "Bad thing",
  image = "downNews",
  trigger = {"POST"},
  temporary = 3,
  defaultPointGain=-3,
})

main.defineNews("volatileNews", {
  name = "Volatility",
  image = "volatileNews",
  description = "Make round-start price change bigger",
  trigger = {"POST"},
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
  trigger = {"POST"},
  temporary = 2,
  onActivate = function ()
    local chart = system.getStorage("main:chart")
    if chart then
      chart.volatility = math.max(0, chart.volatility - 0.1)
    end
  end
})