main.ui.defineButton("startTurn", {
  width = 256,
  height = 128,
  onButtonUpImage = "startTurnUp",
  onButtonDownImage = "startTurnDown",
  renderLayer = 101,
  screenSpace = true,

  -- onDraw = function (ent)

  -- end,
  onButtonClicked = function (ent)
    system.call("main:startTurn")
  end
})