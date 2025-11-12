local cover
-- local buyButton
local reroll
local continue

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("shop", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20})
  reroll = main.ui.spawnUI("rerollButton", {x=70, y=250})
  continue = main.ui.spawnUI("continueButton", {x=70, y=400})
  main.shop.spawnCards()
  main.drawCardTillMaxCapacity()

  local roundsPerDay = system.getStorage("main:roundsPerDay")
  system.updateStorage("main:roundsRemaining", roundsPerDay)

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end
  main.showCharts()
  main.card.updateAllCardPositionBackToOriginalPosition()
end, function ()

  deleteAll({cover, reroll, continue})
  for i=#main.card.shop, 1, -1 do
    local card = main.card.shop[i]
    main.deleteCard(card)
  end

  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    main.addCardToDraw(card)
  end
end)