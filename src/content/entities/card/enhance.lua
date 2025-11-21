--spawns news that last only for the current encounter blabla
main.definePlaceableNewsCard("cultivate", {
  name = "Cultivate",
  image = "cultivate",
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

main.definePlaceableNewsCard("lullaby", {
  name = "Lullaby",
  image = "lullaby",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "lullabyNews",
  trigger = {"CARDTRIGGER"},
  defaultDrawCard = 1,
})

main.definePlaceableNewsCard("dread", {
  name = "Dread",
  image = "dread",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "dreadNews",
  trigger = {"CARDTRIGGER"},
  defaultPriceGain = -6,
})