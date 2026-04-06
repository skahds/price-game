main.defineCard("amplifier", {
  name = "Amplifier",
  image = "amplifier",
  description = "Card to the right gains {repeatColor}+1 REPEAT{/repeatColor}",
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",

  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      main.changeEntityComponent(target, "repeatActivation", 1, combiner.ADD)
    end
  end
})

main.defineCard("whitewash", {
  name = "Whitewash",
  image = "whitewash",
  description = "News in area gains {priceColor}+2 PRICE",
  trigger = {"DEPLOY"},
  price = 2,
  target = {
    shape = {w=3, h=3},
    onActivate = function (ent, targetEnt)
      main.changeEntityComponent(targetEnt, "defaultPriceGain", 2, combiner.ADD)
    end
  },
  rarity = "COMMON",
})

main.defineCard("void", {
  name = "Void",
  image = "void",
  energy = 0,
  description = "Destroy card to the right",
  trigger = {"DEPLOY"},
  temporary = 1,
  price = 2,
  rarity="UNIQUE",
  
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      main.tryDestroyEntity(target)
    end
  end
})

main.defineCard("vision", {
  name = "Vision",
  image = "vision",
  defaultDrawCard = 3,
  trigger = {"DEPLOY"},
  price = 2,
  rarity = "RARE",
})

main.defineCard("reserve", {
  name = "Reserve",
  image = "reserve",
  defaultEnergyGain=1,
  energy = 0,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
})

main.defineCard("sigil", {
  name = "Sigil",
  image = "sigil",
  description = "Doubles current {energyColor}ENERGY",
  trigger = {"DEPLOY"},
  price = 3,
  onActivate = function ()
    local energy = system.getStorage("main:energy")
    main.addEnergy(energy)
  end,
  rarity = "RARE",
})

main.defineCard("augment", {
  name = "Augment",
  image = "augment",
  description = "Spend all energy, Card to\nthe right gains that many {repeatColor}REPEAT{/repeatColor}",
  energy=0,
  trigger = {"DEPLOY"},
  price = 3,
  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      local energy = system.getStorage("main:energy")
      main.addEnergy(-energy)
      main.changeEntityComponent(target, "repeatActivation", energy, combiner.ADD)
    end
  end,
  rarity = "RARE",
})

main.defineCard("secondPlan", {
  name = "Second Plan",
  image = "secondPlan",
  description = "Discard all cards in hand",
  energy = 1,
  defaultDrawCard = 4,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  unlock = {type="metashop"},
  onActivate = function ()
    main.discardCurrentCardsInHand()
  end
})

main.defineCard("grant", {
  name = "Grant",
  image = "grant",
  energy = 1,
  description = "Card to the right gains {multColor}+1 MULT",
  trigger = {"DEPLOY"},
  temporary=3,
  price = 4,
  rarity = "RARE",

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)

    if target then
      main.changeEntityComponent(target, "defaultMultGain", 1, combiner.ADD)
    end
  end
})

main.defineCard("reap", {
  name = "Reap",
  image = "reap",
  description = "If there is a card to the right,\ndestroy it and gain {multColor}X0.5 MULT{/multColor}",
  energy = 1,
  trigger = {"DEPLOY"},
  price = 4,
  rarity = "EPIC",

  filter=function (ent)
    local rightCard = main.getCardBesides(ent, 1)
    if rightCard then
      return true
    end
  end,

  onActivate = function (ent)
    local rightCard = main.getCardBesides(ent, 1)

    if rightCard then
      local success = main.tryDestroyEntity(rightCard)
      if success then
        main.changeEntityComponent(ent, "defaultMultMultiplier", 0.5, combiner.ADD)
      end
    end
  end
})

main.defineCard("doubleDown", {
  name = "Double down",
  image = "doubleDown",
  trigger = {"DEPLOY"},
  defaultPriceMultiplier = 2,
  price = 3,
  rarity  = "RARE",
})

main.defineCard("rift", {
  name = "Rift",
  image = "rift",
  trigger = {"DEPLOY"},
  defaultMultMultiplier = 2,
  price = 3,
  rarity  = "RARE",
})

main.defineCard("parachute", {
  name = "Parachute",
  image = "parachute",
  trigger = {"DEPLOY"},
  defaultMultMultiplier = 1.5,
  energy=0,
  price = 3,
  rarity  = "RARE",
  unlock = {type="metashop"},
  onActivate = function (ent)
    local mult = system.getStorage("main:mult")
    main.addMult(math.floor(mult/2+0.5))
  end
})

main.defineCard("lastHope", {
  name = "Last Hope",
  image = "lastHope",
  description = "Discard all cards in hand,\ndraw 1 CARD and\ngive it {repeatColor}+3 REPEAT{/repeatColor}",
  energy = 1,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "RARE",
  onActivate = function ()
    main.discardCurrentCardsInHand()
    local card = main.drawCard()
    if card then
      main.changeEntityComponent(card, "repeatActivation", 3, combiner.ADD)
    end
  end
})

main.defineCard("relay", {
  name = "Relay",
  image = "relay",
  description = "Trigger and discard card to the right",
  trigger = {"DEPLOY"},
  energy=0,
  price = 4,
  rarity = "EPIC",

  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target and main.canTriggerFullCheck(target, "DEPLOY") then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      local pipeline = main.getPipeline("main")
      pipeline:add(0.5, function ()
        main.triggerEnt(target, "DEPLOY")
        main.discardCard(target)
      end)
    end
  end
})

main.defineCard("spirit", {
  name = "Spirit",
  image = "spirit",
  description = "If there are fewer\nthan 3 cards in hand,",
  trigger = {"DEPLOY"},
  energy=0,
  price = 3,
  rarity = "RARE",
  unlock = {type="metashop"},
  defaultDrawCard=2,

  filter = function (ent)
    if #main.card.hand < 3 then
      return true
    end
  end,
})

main.defineCard("mitosis", {
  name = "Mitosis",
  image = "mitosis",
  description = "Double this card's {priceColor}PRICE{/priceColor}\nand it permanently costs {energyColor}+1 ENERGY",
  trigger = {"DEPLOY"},
  energy=0,
  price = 3,
  rarity = "RARE",
  unlock = {type="metashop"},
  defaultPriceGain=-10,

  onActivate = function (ent)
    main.changeEntityComponent(ent, "defaultPriceGain", 2, combiner.MULTIPLY)
    ent.energy = ent.energy + 1
  end,
})

main.defineCard("snatch", {
  name = "Snatch",
  image = "snatch",
  description = "Draw all cards that is {energyColor}FREE{energyColor}\nfrom your draw pile",
  energy = 0,
  trigger = {"DEPLOY"},
  price = 2,
  rarity = "RARE",
  onActivate = function ()
    local pipeline = main.getPipeline("main")
    for i, card in ipairs(main.card.draw) do
      if card.overrideEnergy == 0 then
        pipeline:add(0.25, function ()
          main.cardToHand(card)
        end)
      end
    end
  end
})

main.defineCard("portableGenerator", {
  name = "Portable Generator",
  image = "portableGenerator",
  description = "Card to the right generates {energyColor}+1 ENERGY{/energyColor}\nand costs {energyColor}+1 ENERGY",
  temporary=1,
  energy = 0,
  trigger = {"DEPLOY"},
  price = 3,
  rarity = "EPIC",

  filter = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      return true
    end
  end,
  
  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)
    if target then
      main.changeEntityComponent(target, "defaultEnergyGain", 1, combiner.ADD)
      target.energy = target.energy + 1
      target.overrideEnergy = target.overrideEnergy + 1
    end
  end
})

main.defineCard("arrow", {
  name = "Arrow",
  image = "arrow",
  description = "Spend all energy, give\n{priceColor}-23 PRICE{/priceColor} for each",
  energy=0,
  trigger = {"DEPLOY"},
  price = 3,
  
  onActivate = function (ent)
    local energy = system.getStorage("main:energy")
    main.addPrice(-23*energy)
    main.addEnergy(-energy)
  end,
})

main.defineCard("ray", {
  name = "Ray",
  image = "ray",
  description = "Spend all energy, give\n{multColor}+5 MULT{/multColor} for each",
  energy=0,
  trigger = {"DEPLOY"},
  price = 3,
  
  onActivate = function (ent)
    local energy = system.getStorage("main:energy")
    main.addMult(5*energy)
    main.addEnergy(-energy)
  end,
})

main.defineCard("ripples", {
  name = "Ripples",
  image = "ripples",
  description = "Give {multColor}+3 MULT{/multColor} for each\ncards in the draw pile",
  energy=1,
  trigger = {"DEPLOY"},
  price = 3,
  
  onActivate = function (ent)
    local cards = #main.card.draw
    if cards and cards > 0 then
      main.addMult(cards*3)
    end
  end,
})

main.defineCard("cargo", {
  name = "Cargo",
  description = "Creates a Junk in\nthe draw pile",
  descriptionTagEntity = "junk",
  defaultPriceGain = -40,
  image = "cargo",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    main.basicSpawnCard("junk", {}, ent, "draw")
  end
})

main.defineCard("algae", {
  name = "Algae",
  description = "Discard a random\ncard in hand",
  defaultPriceGain = 30,
  image = "algae",
  trigger = {"DEPLOY"},
  price = 3,
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end
})

-- main.defineCard("cell", {
--   name = "Cell",
--   image = "cell",
--   description = "Card to the right\nbecomes {energyColor}FREE{/energyColor}",
--   energy = 1,
--   trigger = {"DEPLOY"},
--   price = 3,
--   rarity = "COMMON",

--   filter = function (ent)
--     local target1 = main.getCardBesides(ent, -1)
--     local target2 = main.getCardBesides(ent, 1)
--     if target1 or target2 then
--       return true
--     end
--   end,
  
--   onActivate = function (ent)
--     local target1 = main.getCardBesides(ent, -1)
--     local target2 = main.getCardBesides(ent, 1)
--     if target1 then
--       target1.overrideEnergy = 0
--     end
--     if target2 then
--       target2.overrideEnergy = 0
--     end
--   end
-- })

main.defineCard("fracture", {
  name = "Fracture",
  image = "fracture",
  description = "If there are more cards\nin the draw pile than\nthe discard pile, draw\ncards until it's equal",
  trigger = {"DEPLOY"},
  energy=1,
  price = 4,
  rarity = "EPIC",
  unlock = {type="metashop"},

  filter = function (ent)
    if #main.card.draw > #main.card.discard then
      return true
    end
  end,

  onActivate = function (ent)
    local pipeline = main.getPipeline("main")
    for i=1, #main.card.draw-#main.card.discard do
      if i ~= 1 then
        pipeline:add(0.25, function ()
          main.drawCard()
        end)
      end
    end
  end
})