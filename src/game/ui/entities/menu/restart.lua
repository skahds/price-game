-- TEMPORARY
main.ui.defineButton("restart", {
  width = 200,
  height = 80,
  color = {0.5, 0.7, 0.6},
  renderLayer = 101,
  screenSpace = true,
  text = "RESTART",
  audio = "breaker",
  onButtonClicked = function (ent)
    love.event.restart()
  end
})