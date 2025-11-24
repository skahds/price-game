main.ui.defineButton("loadGame", {
  width = 220,
  height = 120,
  color = {0.6, 0.6, 0.9},
  renderLayer = 101,
  screenSpace = true,
  text = "CONTINUE",
  audio = "breaker",
  onButtonClicked = function (ent)
    system.loadGame()
  end
})