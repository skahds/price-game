main.ui.defineUI("levelSelect", {
  -- change these when spawned
  name = "Level",
  description = "nothing much here",
  image = "levelSelect",
  text = "1",
  renderLayer = 4,
  reward = 0,
  showDescription = true,
  width = 64,
  height= 64,
  screenSpace = false,
  scoreRequirement = 0,
  onMouseReleased = function (ent, button)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      main.playScene("play")
    end
  end,
})