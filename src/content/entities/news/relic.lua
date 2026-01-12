main.defineNews("discount", {
  name = "Discount",
  image = "discountNews",
  trigger = {"EACHTURN"},
  description = "A random card becomes {energyColor}FREE{/energyColor}",
  isRelic = true,
  onActivate = function (ent)
    local card = main.getRandomCard(function (card)
      return card.overrideEnergy > 0
    end)
    if card and card.overrideEnergy > 0 then
      card.overrideEnergy = 0
    end
  end,
  rarity = "COMMON"
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
  rarity = "COMMON",
  onActivate = function ()
    main.shuffleDiscardToDraw()
  end
})

main.defineNews("powerCore", {
  name = "Power Core",
  image = "powerCoreNews",
  description = "A random card in the\ndeck costs {energyColor}-1 ENERGY",
  trigger = {"ENCOUNTER"},
  temporary=3,
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    local card = main.getRandomCard("discard", "draw", "hand", function (card)
      if card.energy == 0 then return false else return true end
    end)
    if card then
      card.energy = card.energy - 1
      card.overrideEnergy = math.max(card.overrideEnergy-1, 0)
    end
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
  rarity = "COMMON",
  onActivate = function ()
    local card = main.basicSpawnCard("junk", {}, nil, "hand")
    main.changeEntityComponent(card, "repeatActivation", 7, combiner.ADD)
  end
})

main.defineNews("bluePill", {
  name = "Blue Pill",
  image = "bluePillNews",
  description = "Destroy all {priceColor}PRICE{/priceColor} STARTER cards in\ndeck and create 4 random {rareColor}COMMON+{/rareColor} card",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    for k, pile in ipairs(main.getAllPiles()) do
      for i=#pile, 1, -1 do
        local card = pile[i]
        if card.rarity.id == "STARTER" and (card.id == "add" or card.id == "subtract") then
          main.deleteCard(card)
        end
      end
    end

    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="COMMON", amount=4})
    for k, card in ipairs(t) do
      main.basicSpawnCard(card, {}, nil, "hand")
    end
  end
})

main.defineNews("doppelganger", {
  name = "Doppelganger",
  image = "doppelgangerNews",
  description = "Create 2 copies of your leftmost card",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "COMMON",
  onActivate = function ()
    local card = main.getCardInOrder(1)
    if card then
      for i=1, 2 do
        main.basicSpawnCard(card.id, main.getAllComponentsFromEntity(card), nil, "hand")
      end
    end
  end
})

main.defineNews("surplus", {
  name = "Surplus",
  image = "surplusNews",
  description = "Increase shop offer amount by 2",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "COMMON",
  onActivate = function ()
    system.updateStorage("shop:maxCardAmount", system.getStorage("shop:maxCardAmount")+2)
  end
})

main.defineNews("marbles", {
  name = "Marbles",
  image = "marblesNews",
  description = "Draw all cards that is {energyColor}FREE{energyColor}",
  trigger = {"ENCOUNTER"},
  isRelic = true,
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

main.defineNews("chickenGame", {
  name = "Chicken Game",
  image = "chickenGameNews",
  description = "Creates a copy of that card",
  trigger = {"CARDTRIGGER"},
  temporary=5,
  isRelic = true,
  rarity = "RARE",
  onActivate = function (ent, card)
    if card then
      main.basicSpawnCard(card.id, main.getAllComponentsFromEntity(card), nil, "hand")
    end
  end
})

main.defineNews("warBanner", {
  name = "War Banner",
  description = "Your card with COMMON\nrarity gains {repeatColor}+2 REPEAT",
  image = "warBannerNews",
  trigger = {"EACHTURN"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    for i, card in ipairs(main.card.hand) do
      if card.rarity.id == "COMMON" then
        main.changeEntityComponent(card, "repeatActivation", 2, combiner.ADD)
      end
    end
  end
})

main.defineNews("seedOfLight", {
  name = "Seed Of Light",
  description = "A random card in the deck becomes\n{energyColor}FREE{/energyColor} and gains {repeatColor}+4 REPEAT",
  image = "seedOfLightNews",
  trigger = {"ENCOUNTER"},
  isRelic = true,
  rarity = "RARE",
  onActivate = function ()
    local card = main.getRandomCard("discard", "draw", "hand")
    if card then
      card.overrideEnergy = 0
      main.changeEntityComponent(card, "repeatActivation", 4, combiner.ADD)
    end
  end
})

main.defineNews("sceptre", {
  name = "Sceptre",
  description = "{multColor}X MULT{/multColor} by {multColor}0.5{/multColor} for each\ncards in hand",
  image = "sceptreNews",
  trigger = {"ROUND"},
  isRelic = true,
  rarity = "RARE",
  onUpdate = function (ent)
    ent.description = "{multColor}X MULT{/multColor} by {multColor}0.5{/multColor} for each\ncards in hand (currently {multColor}X" .. 1+math.floor(#main.card.hand/2+0.6) .."{/multColor})"
  end,
  onActivate = function ()
    main.multiplyMult(1+math.floor(#main.card.hand/2+0.6))
  end
})