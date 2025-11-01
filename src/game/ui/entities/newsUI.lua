main.ui.defineUI("news_ui", {
  image = "blankNews",
  color = {1, 1, 1, 0.7},
  defaultWidth = 32,
  defaultHeight = 32,
  screenSpace = false,
  renderLayer = 10,
  onHover = function (ent)
    system.call("main:newsHovered", ent.parent)
  end,

  onMouseClicked = function (ent, button)
    system.call("main:newsClicked", ent.parent, button)
  end
})