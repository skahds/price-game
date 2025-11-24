main.ui.defineButton("rerollButton", {
  width = 360,
  height = 100,
  color = {0.4, 0.7, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "Reroll {moneyColor}$3{/moneyColor}",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.tryReroll(system.getStorage("shop:currentRerollPrice"), ent)
  end
})