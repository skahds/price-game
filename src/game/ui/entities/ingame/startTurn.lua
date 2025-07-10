main.ui.defineButton("startTurn", {
  width = 256,
  height = 128,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,

  -- onDraw = function (ent)

  -- end,
  onButtonClicked = function (ent)
    system.call("main:startTurn")
  end
})