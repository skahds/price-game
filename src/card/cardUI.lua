main.ui.defineUI("card_ui", {
  image = "blank_card",
  defaultWidth = 64,
  defaultHeight = 64,
  sx=1.7,
  sy=1.7,
  screenSpace = true,
  renderLayer = 140,
  onHover = function (ent)
    system.call("main:cardHovered", ent.parent)
    -- love.graphics.print(ent.parent.cardOrder, ent.x, ent.y+60)
  end,

  onReleased = function (ent)
    if ent.parent and ent.parent.onReleased then
      ent.parent:onReleased()
    end
  end,

  onMouseClicked = function (ent, button)
    system.call("main:cardClicked", ent.parent, button)
  end
})