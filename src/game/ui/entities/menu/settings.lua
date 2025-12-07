main.ui.defineButton("openSetting", {
  width = 200,
  height = 100,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "SETTING",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.ui.gameSettings()
  end
})