main.ui.defineUI("card_ui", {
  image = "blank_card",
  defaultWidth = 64,
  defaultHeight = 64,
  screenSpace = true,
  onHover = function (ent)
    system.call("main:cardHovered", ent.card)
  end,

  onReleased = function (ent)
    system.call("main:cardReleased", ent.card)

    if ent.card and ent.card.onReleased then
      ent.card:onReleased()
    end

    local flux = system.getStorage("flux")
    ent.tween = flux.to(ent, 1, { x = 200, y = 200 })
  end,

  onClicked = function (ent)
    system.call("main:cardClicked", ent.card)
  end
})