main.ui.defineUI("spawnCard", {
  width = 64,
  height = 64,
  image = "testBox",
  renderLayer = 101,
  screenSpace = true,

  onDraw = function (ent)

  end,
  onMouseReleased = function (ent)
    main.createCard("testCard", {})
  end
})