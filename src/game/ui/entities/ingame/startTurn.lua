main.ui.defineButton("startTurn", {
  width = 150,
  height = 75,
  mult = 1,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "PLAY",
  audio = "breaker",
  onButtonClicked = function (ent)
    system.updateStorage("main:ownedPercentage", ent.mult*100)
    system.call("main:startTurn")
  end
})