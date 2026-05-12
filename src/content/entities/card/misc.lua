main.definePlaceableNewsCard("examplePlaceable", {
  name = "Example Positive",
  image = "examplePlaceable",
  trigger= {"DEPLOY"},
  rarity = "UNIQUE",
}, {
  image = "upNews",
  trigger = {"ROUND"},
  defaultPriceGain=10,
})

system.on("main:sceneChanged", function ()
  local scene = system.getStorage("main:currentScene")
  if scene == "levelEnd" then
    for i, card in pairs(main.getDeckCards()) do
      if card.id == "examplePlaceable" then
        main.deleteCard(card)
      end
    end
  end
end)