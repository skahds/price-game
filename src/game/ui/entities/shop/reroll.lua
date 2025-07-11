
main.ui.defineButton("rerollButton", {
  width = 360,
  height = 100,
  color = {0.4, 0.7, 0.4},
  renderLayer = 101,
  screenSpace = true,
  -- text = "{moneyColor}REROLL{/moneyColor}",
  text = "REROLL {moneyColor}$1{/moneyColor}",
  audio = "breaker",
  onButtonClicked = function (ent)
    local pipeline = main.getPipeline("main")
    if #pipeline.pipeline == 0 then
      system.call("shop:reroll")
    end
  end
})