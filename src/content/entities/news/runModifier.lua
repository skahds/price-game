main.defineNews("emptyBox", {
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
})