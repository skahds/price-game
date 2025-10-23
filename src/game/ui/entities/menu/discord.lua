main.ui.defineButton("discord", {
  width = 200,
  height = 100,
  color = {0.5, 0.5, 0.8},
  renderLayer = 101,
  screenSpace = true,
  text = "DISCORD",
  audio = "breaker",
  onButtonClicked = function (ent)
    love.system.openURL("https://discord.gg/RB9q3Tn2h8")
  end
})