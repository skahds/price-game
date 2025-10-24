main.defineCard("advancer", {
  name = "Advancer",
  isRelic = true,
  isHollow = true,
  image = "advancer",
  description = "Card to the right gains {multColor}+2 mult",
  trigger = {"ROUND"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)

    if target then
      main.changeEntityComponent(target, "defaultMultGain", 2, combiner.ADD)
    end
  end
})

main.defineCard("retribution", {
  name = "Retribution",
  image = "retribution",
  isRelic = true,
  isHollow = true,
  description = "Destroys card to the left and\ngain 2x its price as {pointColor}points",
  trigger = {"ROUND"},
  price = 4,
  rarity = "EPIC",

  onActivate = function (ent)
    local leftCard = main.getCardBesides(ent, -1)

    if leftCard then
      local price = leftCard.price
      local success = main.tryDestroyEntity(leftCard)
      if success then
        main.changeEntityComponent(ent, "defaultPointGain", price*2, combiner.ADD)
      end
    end
  end
})
