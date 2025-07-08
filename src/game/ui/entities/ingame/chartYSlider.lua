main.ui.defineSlider("scaleYSlider", {
  width = 40,
  height = 200,
  renderLayer = 230,
  slideDirection = "vertical",
  slideAmount = 0.85,
  screenSpace = true,

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

    system.render(231, function ()
      --circle thing in the middle
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.circle("fill", x, y, ent.width/2)


      -- text
      love.graphics.setColor(1, 1, 1)
      local text = "scale: " .. (ent.slideAmount)*100 .. "%"
      local font = system.getStorage("defaultFont")
      local textWidth = font:getWidth(text)
      love.graphics.setFont(font)
      love.graphics.print(text, ent.x+ent.width/2-textWidth/2, ent.y+ent.height*1.2)
    end, ent.screenSpace)

  end,

  onSlide = function (ent, amountScrolled)
    -- snaps it by increments of 0.05
    local increment = 1 / ( 0.05 )
    local slideAmount = math.floor(amountScrolled*increment+0.5)/increment
    ent.slideAmount = slideAmount

    system.updateStorage("main:priceYScale", slideAmount)
  end
})