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
  rarity = "RARE",
  unlock = {type="metashop", demoAvailable=true},
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
  radarCounter = 1,
  description = "Every 2nd activation:\ndraw 1 CARD",
  onUpdate = function (ent)
    ent.description = "Every 2nd activation:\ndraw 1 CARD\n(" .. 3-ent.radarCounter .. " activation left)"
  end,
  onActivate = function (ent)
    if ent.radarCounter == 2 then
      main.drawCard()
      ent.radarCounter = 0
    end

    ent.radarCounter = ent.radarCounter + 1
  end
})

main.definePlaceableNewsCard("decomposite", {
  name = "Decomposite",
  image = "decomposite",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE",
  unlock = {type="metashop"},
}, {
  image = "decompositeNews",
  trigger = {"CARDTRIGGER"},
  decompositeCounter = 1,
  description = "Every 3rd activation:\nmake a random card {energyColor}FREE",
  onUpdate = function (ent)
    ent.description = "Every 3rd activation:\nmake a random card {energyColor}FREE\n(" .. 4-ent.decompositeCounter .. " activation left)"
  end,

  onActivate = function (ent)
    if ent.decompositeCounter == 3 then
      local target = main.getRandomCard("hand")
      if target then
        target.overrideEnergy = 0
      end
      ent.decompositeCounter = 0
    end

    ent.decompositeCounter = ent.decompositeCounter + 1
  end
})