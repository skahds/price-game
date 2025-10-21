main.ui.defineSlider("ownSlider", {
  width = 400,
  height = 80,
  renderLayer = 200,
  slideDirection = "horizontal",
  slideAmount = 0.5,
  screenSpace = true,
  outline = 10,
  outlineBelow = true,
  outlineColor = {0.6, 0.6, 0.6},

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

    system.render(201, function ()
      local x=1280/2
      love.graphics.draw(system.getImage("arrowLeft"), x-200, 70-24, 0, 2, 2)
      love.graphics.draw(system.getImage("arrowLeft"), x+200, 70-24, 0, -2, 2)
    end, true)

    system.render(202, function ()
      --circle thing in the middle
      love.graphics.setColor(0.7, 0.7, 0.7)
      -- if ent.slideAmount-0.5 > 0 then
      --   love.graphics.setColor(0.4, 0.7 + (ent.slideAmount-0.5), 0.4)
      -- elseif ent.slideAmount-0.5 < 0 then
      --   love.graphics.setColor(0.7 + (0.5-ent.slideAmount), 0.4, 0.4)
      -- end
      
      love.graphics.circle("fill", x, y, ent:getHeight()/2.2)


      -- text
      love.graphics.setColor(1, 1, 1)
      -- local frontText = "Buy"
      -- if slideAmount < 0.5 then frontText = "Short" end
      -- if slideAmount == 0.5 then frontText = "Skip" end
      -- local text = frontText .. " " .. (ent.slideAmount-0.5)*200 .. "%"
      local text = "x" .. (ent.slideAmount-0.5)*2
      local font = system.getFont("defaultFont80")
      local textWidth = font:getWidth(text)
      love.graphics.setFont(font)
      love.graphics.print(text, ent.x+ent:getWidth()/2-textWidth/2, ent.y+ent:getHeight()*1.2)
    end, ent.screenSpace)

  end,

  onSlide = function (ent, amountScrolled)
    if system.getStorage("main:isOnTurn") == true then
      return
    end

    -- snaps it by increments of 0.05
    local increment = 1 / ( 0.1 )
    local slideAmount = math.floor(amountScrolled*increment + 0.5)/increment
    ent.slideAmount = slideAmount
    local percentageHold = (slideAmount-0.5)*200
    system.updateStorage("main:ownedPercentage", percentageHold)
    print(percentageHold)
  end
})