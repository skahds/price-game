main.ui.defineButton("spawnCard", {
  width = 160,
  height = 64,
  renderLayer = 110,
  screenSpace = true,
  text="Card",
  color = {0.8, 0.8, 0.8},

  onButtonClicked = function (ent)
    if love.math.random() > 0.5 then
      main.createCard("volatilityCard", {})
    else
      main.createCard("testCard", {})
    end
    
    main.card.updateAllCardPositionBackToOriginalPosition()
  end
})