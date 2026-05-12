main.defineCard("scale", {
  name = "Scale",
  image = "scale",
  description = "If current bar direction\nis different from the\nlast, gain {multColor}+2 MULT{/multColor}",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local secondToLast = chart:getBar(-2)
    local last = chart:getBar(-1)
    if secondToLast == nil or
    (last.endPrice - last.startPrice) * (last.endPrice-last.startPrice) < 0 then
      main.changeEntityComponent(ent, "defaultMultGain", 2, combiner.ADD)
    end
  end,
  rarity = "COMMON",
  unlock = {type="metashop"},
})

main.defineCard("flag", {
  name = "Flag",
  image = "flag",
  description = "Gains {priceColor}-5 PRICE{/priceColor} for\neach green bar",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    chart:forAllBar(function (bar)
      if bar.endPrice - bar.startPrice > 0 then
        main.changeEntityComponent(ent, "defaultPriceGain", -5, combiner.ADD)
      end
    end)
  end,
  rarity = "COMMON",
})

main.defineCard("greenHammer", {
  name = "Green Hammer",
  image = "greenHammer",
  description = "{priceColor}+50 PRICE{/priceColor} if\ncurrent {priceColor}PRICE{/priceColor} is {redColor}negative",
  trigger = {"DEPLOY"},
  price = 3,
  filter = function ()
    local prices = main.getPrice()
    if prices < 0 then
      return true
    end
  end,

  onActivate = function (ent)
    main.addPrice(50)
  end,
  rarity = "COMMON",
})

main.defineCard("redHammer", {
  name = "Red Hammer",
  image = "redHammer",
  description = "{priceColor}-50 PRICE{/priceColor} if\ncurrent {priceColor}PRICE{/priceColor} is {greenColor}positive",
  trigger = {"DEPLOY"},
  price = 3,
    filter = function ()
    local prices = main.getPrice()
    if prices > 0 then
      return true
    end
  end,

  onActivate = function (ent)
    main.addPrice(-50)
  end,
  rarity = "COMMON",
})

main.defineCard("stalemartyr", {
  name = "Stalemartyr",
  image = "stalemartyr",
  description = "Gives {priceColor}PRICE{/priceColor} inverse to\n the previous bar",
  trigger = {"DEPLOY"},
  price = 3,

  onActivate = function (ent)
    local bar = system.getStorage("main:chart"):getBar(-2)
    if bar then
      local price = bar.endPrice - bar.startPrice
      main.addPrice(-price)
    end
  end,
  rarity = "COMMON",
  unlock = {type="metashop", demoAvailable=true},
})