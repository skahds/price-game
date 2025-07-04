main.ui.defineUI("startTurn", {
  width = 128,
  height = 64,
  image = "startTurn",
  renderLayer = 101,
  screenSpace = true,

  onDraw = function (ent)

  end,
  onClicked = function (ent)
    system.call("main:startTurn")
  end
})