main.ui.defineButton("buyButton", {
  width = 128,
  height = 128,
  color = {1, 0.8, 0.3},
  screenSpace = true,
  renderLayer = 50,
  text = "BUY",
  onButtonClicked = function (ent, button)
    if button ~= 1 then
      return
    end
    system.call("shop:buyButtonClicked")
  end
})