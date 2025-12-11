--[[
run modifiers:
-hand size is turned to 2, when a card is triggered, draw a card
-energy is increased to 20, when a card is triggered, increase its energy cost by 1
-when a card is triggered, destroy it and create a random card
]]

main.defineRunModifier({
  definition={
  name = "Jailed Hand",
  news = {"lock", "blueOnion"}
}, lock={
  name = "Lock",
  image = "lockNews",
  description = "Reduce hand size by 3",
  trigger = {"OBTAIN"},
  isRelic = true,
  rarity = "UNIQUE",
  onActivate = function (ent, card)
    print("uorah")
    system.updateStorage("main:maxCardAmount", math.max(0, system.getStorage("main:maxCardAmount")-3))
  end
}, blueOnion={
  name = "Blue Onion",
  image = "blueOnionNews",
  trigger = {"CARDTRIGGER"},
  defaultDrawCard=1,
  isRelic = true,
  rarity = "UNIQUE",
}})


main.defineRunModifier({
  definition={
  name = "Empty Box",
  news = {"emptyBox"}
}, emptyBox={
  name = "Empty Bod",
  image = "emptyBoxNews",
  description = "Destroy it and create a random card",
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
