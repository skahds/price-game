main.ui.defineButton("spawnCard", {
  width = 64,
  height = 64,
  image = "testBox",
  renderLayer = 101,
  screenSpace = true,

  onDraw = function (ent)

  end,
  onButtonClicked = function (ent)
    if love.math.random() > 0.5 then
      main.createCard("volatilityCard", {})
    else
      main.createCard("testCard", {})
    end
    
    main.card.updateAllCardPositionBackToOriginalPosition()
  end
})