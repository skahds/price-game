main.defineRunMode({
  definition={
  name = "Sealed eye",
  news = {"lock", "foresight"}
}, lock={
  name = "Lock",
  image = "lockNews",
  description = "Reduce hand size by 3",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent, card)
    system.updateStorage("main:maxCardAmount", math.max(0, system.getStorage("main:maxCardAmount")-3))
  end
}, foresight={
  name = "Foresight",
  image = "foresightNews",
  trigger = {"CARDTRIGGER"},
  defaultDrawCard=1,
  isRelic = true,
  rarity = "UNIQUE",
}})


main.defineRunMode({
  definition={
  name = "Empty Box",
  news = {"emptyBox"}
}, emptyBox={
  name = "Empty Box",
  image = "emptyBoxNews",
  description = "Destroy it and\ncreate a random card",
  trigger = {"CARDTRIGGER"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent, card)
    if card then
      local bag = system.getStorage("rarity:bag")
      local c = bag:getRandomCard()
      main.basicSpawnCard(c, {}, card, "hand")
      main.deleteCard(card)
    end
  end
}})

main.defineRunMode({
  definition={
  name = "Revelation",
  news = {"localSpace", "scatter"}
}, localSpace={
  name = "Local Space",
  image = "localSpaceNews",
  description = "Increase hand size by 2",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent, card)
    system.updateStorage("main:maxCardAmount", system.getStorage("main:maxCardAmount")+2)
  end
}, scatter={
  name = "Scatter",
  image = "scatterNews",
  description = "Discard a random card",
  trigger = {"CARDTRIGGER"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.discardCard(card)
    end
  end,
}})

main.defineRunMode({
  definition={
  name = "Machine",
  news = {"chained", "piston"}
}, chained={
  name = "Chained",
  image = "chainedNews",
  description = "{energyColor}-1 MAX ENERGY",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent, card)
    system.updateStorage("main:energyPerTurn", math.max(0, system.getStorage("main:energyPerTurn")-1))
    system.updateStorage("main:energy", system.getStorage("main:energyPerTurn"))
  end
}, piston={
  name = "Piston",
  image = "pistonNews",
  description = "A random card\ngains {repeatColor}+1 REPEAT",
  trigger = {"CARDTRIGGER"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent)
    local card = main.getRandomCard()
    if card then
      main.changeEntityComponent(card, "repeatActivation", 1, combiner.ADD)
    end
  end,
}})