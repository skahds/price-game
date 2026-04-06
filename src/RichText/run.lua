local textTable = system.getStorage("textsTable")

system.on("@update", function ()
  for _, t in pairs(textTable) do
    local text = t.richText
    text:update()
  end
end)

local function angleToVec2(angle)
  return math.cos(angle), math.sin(angle)
end

local function drawOutline(t, posX, posY)
  local fixed = true
  if t.screenSpace == false then
    fixed = false
  end

  local renderLayer = t.renderLayer or 50
  system.render(renderLayer, function ()
    local text = t.richText
    local x = posX or 0
    local y = posY or 0
    local r = t.r or 0
    local sx = t.sx or 1
    local sy = t.sy or 1
    local ox = t.ox or 0
    local oy = t.oy or 0
    local color
    if t.outlineColor then
      color = t.outlineColor
    elseif t.color then
      color = {t.color[1]/1.5, t.color[2]/1.5, t.color[3]/1.5}
    else
      color = {0.7, 0.7, 0.7}
    end
    
    love.graphics.setColor(color)
    
    -- Calculate outline offset based on scale
    local defaultFont = system.getStorage("defaultFont")
    local fontFactor = (t.richText.font:getWidth(t.format)/defaultFont:getWidth(t.format))^0.5
    local o = 8*math.sqrt(math.max(sx, sy))*fontFactor
    o = math.min(o, 30)

    -- Scale step size by outline size to keep constant sample count
    local stepSize = math.max(1, math.ceil(o / 8))
    
    local cosR = math.cos(r)
    local sinR = math.sin(r)

    for xi = 1, o, stepSize do
      for yi = 1, o, stepSize do
        local offsetX = xi - o/2
        local offsetY = yi - o/2
        
        local rotatedX = offsetX * cosR - offsetY * sinR
        local rotatedY = offsetX * sinR + offsetY * cosR
        
        text:draw(x+rotatedX, y+rotatedY, r, sx, sy, ox, oy)
      end
    end
  end, fixed)
end

system.on("@draw", function ()

  for _, t in pairs(textTable) do
    if t.isVisible ~= false then
      local fixed = true
      if t.screenSpace == false then
        fixed = false
      end
    
      local posX = system.ask("richtext:getX", combiner.ADD, t)
      local posY = system.ask("richtext:getY", combiner.ADD, t)

      if t.outline then
        drawOutline(t, posX, posY)
      end

      -- smoothens up so no double-draw
      if t.insideDeleteQueue ~= true then
        
        system.render(t.renderLayer or 50, function ()
          
          local text = t.richText
          local x = posX or 0
          local y = posY or 0
          local r = t.r or 0
          local sx = t.sx or 1
          local sy = t.sy or 1
          local ox = t.ox or 0
          local oy = t.oy or 0
          love.graphics.setColor(t.color or {1, 1, 1})
          text:draw(x, y, r, sx, sy, ox, oy)
        end, fixed)
      end
    end
  end

end)

system.answer("richtext:getX", function (t)
  return t.x
end)

system.answer("richtext:getY", function (t)
  return t.y
end)


local offsetX = math.pi
system.on("@update", function ()
  offsetX = offsetX + system.getStorage("dt")
  if offsetX > math.pi*2 then
    offsetX = 0
  end
end)

system.answer("richtext:getY", function (t)
  local x = (t.x or 0) - (t.ox or 0) * (t.sx or 1)
  return math.sin((x+offsetX*100)/100)*2
end)