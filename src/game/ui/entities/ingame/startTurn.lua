main.ui.defineButton("startTurn", {
  width = 200,
  height = 100,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "PLAY",

  -- onDraw = function (ent)

  -- end,
  onButtonClicked = function (ent)
    system.call("main:startTurn")
  end
})