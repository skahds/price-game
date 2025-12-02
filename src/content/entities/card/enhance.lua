--spawns news that last only for the current encounter blabla
main.definePlaceableNewsCard("tracker", {
  name = "Tracker",
  image = "tracker",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "cultivateNews",
  trigger = {"CARDTRIGGER"},
  description = "Gains {priceColor}+1 PRICE",
  onActivate = function (ent)
    main.changeEntityComponent(ent, "defaultPriceGain", 1, combiner.ADD)
  end,
})

main.definePlaceableNewsCard("drag", {
  name = "Drag",
  image = "drag",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "dragNews",
  trigger = {"CARDTRIGGER"},
  defaultPriceGain = -6,
})

main.definePlaceableNewsCard("veil", {
  name = "Veil",
  image = "veil",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "veilNews",
  trigger = {"CARDTRIGGER"},
  defaultMultGain = 2,
})

main.definePlaceableNewsCard("radar", {
  name = "Radar",
  image = "radar",
  trigger= {"DEPLOY"},
  price=4,
  rarity = "EPIC"
}, {
  image = "radarNews",
  trigger = {"CARDTRIGGER"},
  description = "1 in 2 chance to draw 1 CARD",
  onActivate = function ()
    if love.math.random() >= 0.5 then
      main.drawCard()
    end
  end
})

main.definePlaceableNewsCard("decomposite", {
  name = "Decomposite",
  image = "decomposite",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "decompositeNews",
  trigger = {"CARDTRIGGER"},
  description = "1 in 3 chance to make a random card {energyColor}FREE",
  onActivate = function ()
    local target = main.getRandomCard("hand")
    target.overrideEnergy = 0
  end
})