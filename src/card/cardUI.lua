main.ui.defineUI("card_ui", {
  image = "blank_card",
  defaultWidth = 64,
  defaultHeight = 64,
  screenSpace = true,
  onHover = function (ent)
    system.call("main:cardHovered", ent.card)
  end,
  onClicked = function (ent)
    system.call("main:cardReleased", ent.card)
  end
})