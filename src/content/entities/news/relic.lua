main.defineNews("discount", {
  name = "Discount",
  image = "discountNews",
  trigger = {"EACHTURN"},
  description = "A random card becomes {energyColor}FREE{/energyColor}",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card and card.overrideEnergy > 0 then
      card.overrideEnergy = 0
    end
  end,
  rarity = "RARE"
})

main.defineNews("dream", {
  name = "Dream",
  image = "dreamNews",
  trigger = {"EACHTURN"},
  isRelic = true,
  defaultDrawCard = 1,
  rarity = "COMMON"
})

main.defineNews("refine", {
  name = "Refine",
  image = "refineNews",
  trigger = {"EACHTURN"},
  description = "Your leftmost card\ngains {repeatColor}+1 REPEAT",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(1)
    main.changeEntityComponent(card, "repeatActivation", 1, combiner.ADD)
  end,
  rarity = "COMMON"
})

main.defineNews("nuclear", {
  name = "Nuclear",
  image = "nuclearNews",
  trigger = {"EACHTURN"},
  description = "Your rightmost card\ngains {repeatColor}+2 REPEAT\nand costs {energyColor}+1 ENERGY",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getCardInOrder(-1)
    main.changeEntityComponent(card, "repeatActivation", 2, combiner.ADD)
    card.overrideEnergy = card.overrideEnergy + 1
  end,
  rarity = "RARE"
})

main.defineNews("burnOff", {
  name = "Burn Off",
  image = "burnOffNews",
  trigger = {"EACHTURN"},
  description = "Make a random card cost {energyColor}+1 ENERGY{/energyColor}",
  defaultEnergyGain = 1,
  isRelic = true,
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      card.overrideEnergy = card.overrideEnergy + 1
    end
  end,
  rarity = "RARE"
})

main.defineNews("focus", {
  name = "Focus",
  image = "focusNews",
  trigger = {"EACHTURN"},
  description = "Discard a random card",
  defaultEnergyGain = 1,
  isRelic = true,
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
  rarity = "RARE"
})

main.defineNews("allOut", {
  name = "All Out",
  image = "alloutNews",
  trigger = {"ENCOUNTER"},
  defaultDrawCard = 2,
  defaultEnergyGain = 1,
  isRelic = true,
  rarity = "RARE"
})

main.defineNews("recycle", {
  name = "Recycle",
  image = "recycleNews",
  description = "Shuffle the discard pile to the draw pile",
  trigger = {"EACHTURN"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    for i, card in ipairs(main.card.discard) do
      main.addCardToDraw(card)
    end
  end
})

main.defineNews("powerCore", {
  name = "Power Core",
  image = "powerCoreNews",
  description = "A random card in the\ndeck costs {energyColor}-1 ENERGY",
  trigger = {"EACHTURN"},
  temporary=3,
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    local card = main.getRandomCard("discard", "draw", "hand", function (card)
      if card.energy == 0 then return false else return true end
    end)
    if card then
      card.energy = card.energy - 1
    end
  end
})

main.defineNews("junkDynamo", {
  name = "Junk Dynamo",
  image = "junkDynamoNews",
  description = "Create 2 Junk",
  descriptionTagEntity = "junk",
  trigger = {"ENCOUNTER"},
  defaultEnergyGain = 1,
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    main.basicSpawnCard("junk", {}, nil, "draw")
    main.basicSpawnCard("junk", {}, nil, "draw")
  end
})

main.defineNews("junkDynamo", {
  name = "Junk Dynamo",
  image = "junkDynamoNews",
  description = "Creates 2 Junk in\nthe draw pile",
  descriptionTagEntity = "junk",
  trigger = {"EACHTURN"},
  defaultEnergyGain = 1,
  isRelic = true,
  rarity = "COMMON",
  onActivate = function ()
    main.basicSpawnCard("junk", {}, nil, "draw")
    main.basicSpawnCard("junk", {}, nil, "draw")
  end
})

main.defineNews("battery", {
  name = "Battery",
  image = "batteryNews",
  description = "Creates a Junk with {repeatColor}+7 REPEAT",
  descriptionTagEntity = "junk",
  trigger = {"ENCOUNTER"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    local card = main.basicSpawnCard("junk", {}, nil, "hand")
    main.changeEntityComponent(card, "repeatActivation", 7, combiner.ADD)
  end
})

main.defineNews("bluePill", {
  name = "Blue Pill",
  image = "bluePillNews",
  description = "destroy all STARTER cards in deck\nand create 4 random {rareColor}RARE+{/rareColor} card",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    for k, pile in ipairs(main.getAllPiles()) do
      for i=#pile, 1, -1 do
        local card = pile[i]
        if card.rarity.id == "STARTER" then
          main.deleteCard(card)
        end
      end
    end

    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="RARE", amount=4})
    for k, card in ipairs(t) do
      main.basicSpawnCard(card, {}, nil, "draw")
    end
  end
})