main.ui.defineButton("saveGame", {
  width = 200,
  height = 120,
  color = {1, 0.5, 0.5},
  renderLayer = 1001,
  screenSpace = true,
  text = "SAVE",
  audio = "breaker",
  onButtonClicked = function (ent)
    system.saveGame()
  end
})

main.ui.defineButton("loadGame", {
  width = 200,
  height = 120,
  color = {1, 0.5, 0.5},
  renderLayer = 1001,
  screenSpace = true,
  text = "LOAD",
  audio = "breaker",
  onButtonClicked = function (ent)
    system.loadGame()
  end
})

main.ui.spawnUI("saveGame", {x=100, y=100})
main.ui.spawnUI("loadGame", {x=100, y=500})