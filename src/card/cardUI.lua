main.ui.defineUI("card_ui", {
  image = "blank_card",
  defaultWidth = 128,
  defaultHeight = 128,
  screenSpace = true,
  renderLayer = 140,
  onHover = function (ent)
    system.call("main:cardHovered", ent.card)
    -- love.graphics.print(ent.card.cardOrder, ent.x, ent.y+60)
  end,

  onReleased = function (ent)
    if ent.card and ent.card.onReleased then
      ent.card:onReleased()
    end
  end,

  onMouseClicked = function (ent)
    system.call("main:cardClicked", ent.card)
  end
})