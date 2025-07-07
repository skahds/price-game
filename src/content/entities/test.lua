main.ui.defineUI("startTurn", {
  width = 64,
  height = 64,
  image = "testBox",
  renderLayer = 101,
  screenSpace = true,

  onDraw = function (ent)

  end,
  onClicked = function (ent)
    main.createCard("testCard", {})
  end
})