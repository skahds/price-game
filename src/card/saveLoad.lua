local piles = {"discard", "draw", "hand"}

system.onSave("card", function ()
  local t = {}
  for _, pile in ipairs(piles) do
    t[pile] = {}
    for _, card in ipairs(main.card[pile]) do
      local cardComps = main.getAllComponentsFromEntity(card)
      cardComps.id = card.id
      table.insert(t[pile], cardComps)
    end
  end
  return t
end)

system.onLoad("card", function (t)
  for _, pile in ipairs(piles) do
    for i=#main.card[pile], 1, -1 do
      local card = main.card[pile][i]
      main.deleteCard(card)
    end
  end

  for pileName, pile in pairs(t) do
    for _, card in ipairs(pile) do
      main.createCard(card.id, card, pileName)
    end
  end
  main.card.updateAllCardPositionBackToOriginalPosition()
end)