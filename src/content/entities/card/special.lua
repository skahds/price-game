main.defineCard("scale", {
  name = "Scale",
  image = "scale",
  description = "If bar direction is\ndifferent than the\nlast, gain{multColor}+4 MULT{/multColor}",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local secondToLast = chart:getBar(-2)
    local last = chart:getBar(-1)
    if secondToLast == nil or
    (last.endPrice - last.startPrice) * (last.endPrice-last.startPrice) < 0 then
      main.changeEntityComponent(ent, "defaultMultGain", 4, combiner.ADD)
    end
  end
})

main.defineCard("flag", {
  name = "Flag",
  image = "flag",
  description = "Gains {priceColor}-10 PRICE{/priceColor} for\neach green bar",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    chart:forAllBar(function (bar)
      if bar.endPrice - bar.startPrice > 0 then
        main.changeEntityComponent(ent, "defaultPriceGain", -10, combiner.ADD)
      end
    end)
  end
})

main.defineCard("greenHammer", {
  name = "Green Hammer",
  image = "greenHammer",
  description = "Gives {priceColor}+50 PRICE{/priceColor} if\ncurrent bar is red",
  trigger = {"DEPLOY"},
  price = 3,
  rarity  = "RARE",
  filter = function ()
    local prices = main.getPrice()
    if prices < 0 then
      main.addPrice(50)
    end
  end,
  onActivate = function (ent)
    main.addPrice(50)
  end
})

main.defineCard("redHammer", {
  name = "Red Hammer",
  image = "redHammer",
  description = "Gives {priceColor}-50 PRICE{/priceColor} if\ncurrent bar is green",
  trigger = {"DEPLOY"},
  price = 3,
  rarity  = "RARE",
  filter = function ()
    local prices = main.getPrice()
    if prices > 0 then
      main.addPrice(-50)
    end
  end,
  onActivate = function (ent)
    main.addPrice(-50)
  end
})

main.defineCard("inversion", {
  name = "Inversion",
  image = "inversion",
  description = "Multiplies {priceColor}PRICE{/priceColor} by -2",
  trigger = {"DEPLOY"},
  price = 3,
  rarity  = "RARE",
  onActivate = function (ent)
    local prices = main.getPrice()
    main.addPrice(prices*-2)
  end
})