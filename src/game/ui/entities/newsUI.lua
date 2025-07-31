main.ui.defineUI("news_ui", {
  image = "blankNews",
  defaultWidth = 64,
  defaultHeight = 64,
  screenSpace = false,
  renderLayer = 140,
  onHover = function (ent)
    system.call("main:newsHovered", ent.parent)
  end,

  onReleased = function (ent)

  end,

  onMouseClicked = function (ent)
    system.call("main:newsClicked", ent.parent)
  end
})