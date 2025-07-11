
main.ui.defineButton("rerollButton", {
  width = 200,
  height = 100,
  color = {0.3, 0.9, 0.3},
  renderLayer = 101,
  screenSpace = true,
  text = "REROLL",
  audio = "breaker",
  onButtonClicked = function (ent)
    local pipeline = main.getPipeline("main")
    if #pipeline.pipeline == 0 then
      system.call("shop:reroll")
    end
  end
})