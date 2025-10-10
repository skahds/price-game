-- main thing to edit when creating: increment, onBasicSliderDraw, targetStorage
main.ui.defineSlider("basicSlider", {
  defaultWidth = 400,
  defaultHeight = 80,
  renderLayer = 200,
  slideDirection = "horizontal",
  slideAmount = 0.5,
  ballColor = {0.6, 0.6, 0.6},
  screenSpace = true,
  increment = 1 / ( 0.1 ),

  onDraw = function (ent)
    
    local slideAmount = ent.slideAmount or 0.5
    local x = ent.x
    local y = ent.y

    if ent.slideDirection == "horizontal" then
      x = x + ent:getWidth() * slideAmount
      y = y + ent:getHeight()/2
    elseif ent.slideDirection == "vertical" then
      y = y + ent:getHeight() * slideAmount
      x = x + ent:getWidth() /2
    end

    system.render(ent.renderLayer+1, function ()
      --circle thing in the middle
      love.graphics.setColor(ent.ballColor)
      love.graphics.circle("fill", x, y, ent:getHeight()/2.2)

      if ent.onBasicSliderDraw then
        ent:onBasicSliderDraw()
      end
    end, ent.screenSpace)

  end,

  onSlide = function (ent, amountScrolled)
    -- snaps it by increments
    local increment = ent.increment
    local slideAmount = math.floor(amountScrolled*increment + 0.5)/increment
    ent.slideAmount = slideAmount
    local percentageHold = (slideAmount)
    if ent.targetStorage then
      system.updateStorage(ent.targetStorage, percentageHold)
    end
  end
})