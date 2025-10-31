local flux = system.getStorage("flux")

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
  onHover = function (ent)
    ent.tween = flux.to(ent, 0.2, {sx=2, sy=2})
    ent.ox = ent.width/2
    ent.oy = ent.height/2
  end,
  notHovered = function (ent)
    ent.tween = flux.to(ent, 0.2, {sx=1, sy=1})
    ent.ox = ent.width/2
    ent.oy = ent.height/2
  end,
  onMouseReleased = function (ent, button)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      main.playScene("play")
    end
  end,
})