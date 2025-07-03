main.ui.defineSlider("ownSlider", {
  width = 200,
  height = 50,
  renderLayer = 100,
  slideDirection = "horizontal",
  slideAmount = 0.5,
  onDraw = function (ent)
    
    local slideAmount = ent.slideAmount or 0.5
    local x = ent.x
    local y = ent.y

    if ent.slideDirection == "horizontal" then
      x = x + ent.width * slideAmount
      y = y + ent.height/2
    elseif ent.slideDirection == "vertical" then
      y = y + ent.height * slideAmount
      x = x + ent.width /2
    end

    system.render(120, function ()
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.circle("fill", x, y, 10)
    end, ent.screenSpace)

  end,
  onSlide = function (ent, amountScrolled)
    ent.slideAmount = amountScrolled
    print(amountScrolled)
  end
})