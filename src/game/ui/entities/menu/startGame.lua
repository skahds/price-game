main.ui.defineButton("menuPlay", {
  width = 300,
  height = 200,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "START",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.playScene("play")
  end
})