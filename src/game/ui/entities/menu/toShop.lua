main.ui.defineButton("continueToShop", {
  width = 360,
  height = 100,
  color = {0.4, 0.4, 0.7},
  renderLayer = 101,
  screenSpace = true,
  text = "Continue",
  audio = "breaker",
  onButtonClicked = function (ent)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      main.playScene("shop")
    end
  end
})