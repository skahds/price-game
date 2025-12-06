main.ui.defineButton("startTurn", {
  width = 200,
  height = 80,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "START",
  audio = "breaker",
  onButtonClicked = function (ent)
    system.call("main:startTurn")
  end
})