main.ui.defineButton("menuPlay", {
  width = 220,
  height = 120,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "START",
  audio = "breaker",
  onButtonClicked = function (ent)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      main.playScene("runSelect")
    end
  end
})