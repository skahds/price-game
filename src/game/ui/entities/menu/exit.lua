main.ui.defineButton("exit", {
  width = 200,
  height = 80,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "EXIT",
  audio = "breaker",
  onButtonClicked = function (ent)
    -- save game later
    love.event.quit()
  end
})