main.ui.defineSlider("ownSlider", {
  width = 400,
  height = 80,
  renderLayer = 200,
  slideDirection = "horizontal",
  slideAmount = 0.5,
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

    system.render(201, function ()
      --circle thing in the middle
      love.graphics.setColor(0.6, 0.6, 0.6)
      love.graphics.circle("fill", x, y, ent.height/2)


      -- text
      love.graphics.setColor(1, 1, 1)
      local frontText = "buy"
      if slideAmount < 0.5 then frontText = "short" end
      local text = frontText .. " " .. (ent.slideAmount-0.5)*200 .. "%"
      local font = system.getStorage("defaultFont")
      local textWidth = font:getWidth(text)
      love.graphics.setFont(font)
      love.graphics.print(text, ent.x+ent.width/2-textWidth/2, ent.y-ent.height*1.2)
    end, ent.screenSpace)

  end,

  onSlide = function (ent, amountScrolled)
    if system.getStorage("main:isOnTurn") == true then
      return
    end

    -- snaps it by increments of 0.05
    local increment = 1 / ( 0.05 )
    local slideAmount = math.floor(amountScrolled*increment + 0.5)/increment
    ent.slideAmount = slideAmount
    local percentageHold = (slideAmount-0.5)*200
    system.updateStorage("main:ownedPercentage", percentageHold)
  end
})