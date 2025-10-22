main.defineCard("scale", {
  name = "Scale",
  image = "scale",
  description = "If Bar direction is\ndifferent than the last, gain\n{multColor}+1 mult{/multColor}, else {multColor}-1 mult{/multColor}",
  trigger = {"POST"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local secondToLast = chart:getBar(-2)
    local last = chart:getBar(-1)
    if secondToLast == nil or
    (last.endPrice - last.startPrice) * (last.endPrice-last.startPrice) < 0 then
      main.changeEntityComponent(ent, "defaultMultGain", 1, combiner.ADD)
    else
      main.changeEntityComponent(ent, "defaultMultGain", -1, combiner.ADD)
    end
  end
})

main.defineCard("flag", {
  name = "Flag",
  image = "flag",
  description = "Gains {pointColor}-5 points{/pointColor} for\neach green bar",
  trigger = {"POST"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    chart:forAllBar(function (bar)
      if bar.endPrice - bar.startPrice > 0 then
        main.changeEntityComponent(ent, "defaultPointGain", -5, combiner.ADD)
      end
    end)
  end
})

main.defineCard("greenHammer", {
  name = "Green Hammer",
  image = "greenHammer",
  description = "Give {pointColor}+50 points{/pointColor} if\ncurrent bar is red",
  trigger = {"POST"},
  price = 3,
  rarity  = "RARE",
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local bar = chart:getBar(-1)
    if bar and bar.endPrice - bar.startPrice < 0 then
      main.addPoint(50)
    end
  end
})

main.defineCard("redHammer", {
  name = "Red Hammer",
  image = "redHammer",
  description = "Give {pointColor}-50 points{/pointColor} if\ncurrent bar is green",
  trigger = {"POST"},
  price = 3,
  rarity  = "RARE",
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local bar = chart:getBar(-1)
    if bar and bar.endPrice - bar.startPrice > 0 then
      main.addPoint(-50)
    end
  end
})