main.ui.defineUI("patterns_ui", {
  image = "blank_card",
  defaultWidth = 48,
  defaultHeight = 64,
  sx=1.4,
  sy=1.4,
  screenSpace = true,
  renderLayer = 120,
  onReleased = function (ent)
    if ent.parent and ent.parent.onReleased then
      ent.parent:onReleased()
    end
  end,

  onMouseClicked = function (ent, button)
    system.call("main:patterns_uiClicked", ent, button)
  end,
})