--spawns news that last only for the current encounter blabla
main.definePlaceableNewsCard("cultivate", {
  name = "cultivate",
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