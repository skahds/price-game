local piles = {"discard", "draw", "hand"}

system.register("cards", 20, function ()
  local t = {}
  for _, pile in ipairs(piles) do
    t[pile] = {}
    for _, card in ipairs(main.card[pile]) do
      local cardComps = main.getAllComponentsFromEntity(card)
      table.insert(t[pile], cardComps)
    end
  end
  return t
end, function (t)
  for _, pile in ipairs(piles) do
    for i=#main.card[pile], 1, -1 do
      local card = main.card[pile][i]
      main.deleteCard(card)
    end
  end

  for pileName, pile in pairs(t) do
    for _, card in ipairs(pile) do
      
      local c = main.createCard(card.id, card, "hand")
      if pileName == "draw" then
        main.addCardToDraw(c)
        c.ui.isVisible = false
      elseif pileName == "discard" then
        main.discardCard(c)
        c.ui.isVisible = false
      end
    end
  end
  main.card.updateAllCardPositionBackToOriginalPosition()
end)