main.defineCard("advancer", {
  name = "Advancer",
  isRelic = true,
  isHollow = true,
  image = "advancer",
  description = "Gives card to the right {multColor}+1 mult",
  trigger = {"POST"},
  price = 2,
  rarity = "EPIC",

  onActivate = function (ent)
    local target = main.getCardBesides(ent, 1)

    if target then
      main.changeEntityComponent(target, "defaultMultGain", 1, combiner.ADD)
    end
  end
})

main.defineCard("retribution", {
  name = "Retribution",
  image = "retribution",
  isRelic = true,
  isHollow = true,
  description = "Destroys card to the left\nand gain its price as {pointColor}points",
  trigger = {"POST"},
  price = 2,
  rarity = "EPIC",

  onActivate = function (ent)
    local leftCard = main.getCardBesides(ent, -1)

    if leftCard then
      local price = leftCard.price
      local success = main.tryDestroyEntity(leftCard)
      if success then
        main.changeEntityComponent(ent, "defaultPointGain", price, combiner.ADD)
      end
    end
  end
})
