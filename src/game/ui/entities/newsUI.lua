main.ui.defineUI("news_ui", {
  image = "blankNews",
  defaultWidth = 32,
  defaultHeight = 32,
  screenSpace = false,
  renderLayer = 10,
  onHover = function (ent)
    system.call("main:newsHovered", ent.parent)
  end,

  onMouseClicked = function (ent)
    system.call("main:newsClicked", ent.parent)
  end
})