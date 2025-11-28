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

main.definePlaceableNewsCard("radar", {
  name = "Radar",
  image = "radar",
  trigger= {"DEPLOY"},
  price=4,
  rarity = "EPIC"
}, {
  image = "radarNews",
  trigger = {"CARDTRIGGER"},
  defaultDrawCard = 1,
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