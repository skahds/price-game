local function sliderUpdate(sliderObject)
  local slideDirection = sliderObject.slideDirection or "horizontal"
  if love.mouse.isDown(sliderObject.button or 1) then
    local mouse

    sliderObject.outline = sliderObject.outline or 0

    if sliderObject.screenSpace == false then
      mouse = system.getStorage("mouse")
    else
      mouse = system.getStorage("realMouse")
    end

    local r = math.min(sliderObject.width, sliderObject.height)/2

    -- made it only work for horizontal sliders since that's the only one on the game
    sliderObject.overrideHitbox = {
      x = sliderObject.x - r - sliderObject.outline/2,
      y = sliderObject.y - sliderObject.outline/2,
      width = sliderObject:getWidth() + r*2 + sliderObject.outline,
      height = sliderObject:getHeight() + sliderObject.outline
    }

    -- onSlide gets itself and slide amount in percentage
    if main.AABB_check(sliderObject.overrideHitbox, mouse) then
      local amountScrolled
      if slideDirection == "horizontal" then
        amountScrolled = (mouse.x - sliderObject.x) / (sliderObject:getWidth())
      elseif slideDirection == "vertical" then
        amountScrolled = (mouse.y - sliderObject.y) / (sliderObject:getHeight())
      end
      -- makes sure it cant go outside of 0-1
      amountScrolled = math.max(0, math.min(1, amountScrolled))
      if sliderObject.onSlide then
        sliderObject.onSlide(sliderObject, amountScrolled)
      end
    end
  end
end

-- tertiery UI, this is the "end product"
function main.ui.defineSlider(id, eType)
  eType.update = sliderUpdate
  main.ui.defineUI(id, eType)
end

system.on("ui:entityDrawn", function (ent)
  if ent.onSlide == nil then
    return
  end

  system.render(ent.renderLayer, function ()
    local color = ent.color
    if color then
      love.graphics.setColor(color)
    end
    local r = math.min(ent.width, ent.height)/2
    love.graphics.circle("fill", ent.x, ent.y+ent.height/2, r)
    love.graphics.circle("fill", ent.x+ent.width, ent.y+ent.height/2, r)
  end, ent.screenSpace)
end)