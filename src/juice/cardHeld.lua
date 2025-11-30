-- system.on("@update", function ()
--   local mouse = system.getStorage("mouse")
--   local x, y = main.grid.toGrid(mouse.x, mouse.y)
--   if main.grid.getNewsInGrid(x, y, 1, 1) then
--     print("CAUGHT")
--   end
-- end)

local flux = system.getStorage("flux")
local collideHeld = true
local pos = {x=0, y=0}

system.on("@update", function ()
  local mouse = system.getStorage("mouse")
  local x, y = main.grid.snapToGrid(mouse.x, mouse.y)
  if collideHeld then
    x, y = main.grid.getClosestAvailableGrid(x, y, 1, 1)
    x, y = main.grid.gridToPos(x, y)
  end
  flux.to(pos, 0.05, {x=x, y=y})
end)

local function drawTargetSize(ent, x, y)
  local xOffsset, yOffset = main.grid.gridSize*ent.target.shape.w, main.grid.gridSize*ent.target.shape.h
  local wOffset, hOffset = (main.grid.gridSize)/2, (main.grid.gridSize)/2
  love.graphics.setColor(1, 0.7, 0.4, 0.35)
  love.graphics.rectangle("fill", x-xOffsset/2+wOffset, y-yOffset/2+hOffset, xOffsset, yOffset)
  love.graphics.setLineWidth(5)
  love.graphics.setColor(1, 0.8, 0.5, 0.6)
  love.graphics.rectangle("line", x-xOffsset/2+wOffset, y-yOffset/2+hOffset, xOffsset, yOffset)
end

system.on("main:newsHovered", function (news)
  if news.target == nil then
    return
  end

  system.render(280, function ()
    drawTargetSize(news, news.x, news.y)
  end)
end)

local function drawDottedCurve(x1, y1, x2, y2, n, curveAmount, offset)
  -- curveAmount controls how much the line curves (0 = straight line)
  -- Positive values curve upward, negative values curve downward
  curveAmount = curveAmount or 50
  
  -- offset shifts the dots along the curve (0-1)
  -- 0 = no offset, 1 = shift by one dot spacing
  offset = offset or 0
  
  -- Calculate midpoint for the curve control point
  local mx = (x1 + x2) / 2
  local my = (y1 + y2) / 2
  
  -- Calculate perpendicular offset for curve
  local dx = x2 - x1
  local dy = y2 - y1
  local len = math.sqrt(dx * dx + dy * dy)
  
  -- Control point perpendicular to the line
  local cx = mx - (dy / len) * curveAmount
  local cy = my + (dx / len) * curveAmount
  
  -- Draw dots along the quadratic bezier curve
  for i = 0, n - 1 do
    -- Apply offset to the parameter t
    local t = (i + offset-1) / (n - 1)
    local invT = 1 - t
    
    -- Quadratic bezier formula
    local x = invT * invT * x1 + 2 * invT * t * cx + t * t * x2
    local y = invT * invT * y1 + 2 * invT * t * cy + t * t * y2
    
    love.graphics.points(x, y)
  end
end


local info={oppacity=1, dottedLineOffset=0}

system.on("@draw", function ()
  local cardHeld = system.getStorage("main:currentSelectedCard")
  if cardHeld == nil then
    info.oppacity=1
    return
  end

  info.dottedLineOffset = info.dottedLineOffset + system.getStorage("dt")
  if info.dottedLineOffset > 1 then
    info.dottedLineOffset = 0
  end

  if info.oppacity >= 0.99 then
    flux.to(info, 1, {oppacity=0.5})
  elseif info.oppacity <= 0.51 then
    flux.to(info, 1, {oppacity=1})
  end
  

  local entWithTarget
  if cardHeld.spawnNews then
    local e = main.entities[cardHeld.spawnNews].definition
    if e.target then
      entWithTarget = e
    end
    collideHeld = true
  elseif cardHeld.target then
    entWithTarget = cardHeld
    collideHeld = false
  end


  system.render(280, function ()
    if entWithTarget then
      drawTargetSize(entWithTarget, pos.x, pos.y)
    end

    if cardHeld.spawnNews then
      local news = main.entities[cardHeld.spawnNews].definition
      love.graphics.setColor(1, 1, 1, 0.8)
      love.graphics.draw(system.getImage(news.image), pos.x, pos.y)
    end
  end)

  system.render(cardHeld.ui.renderLayer-1, function ()
    local ui = cardHeld.ui
    local size=6
    love.graphics.setColor(0.9, 0.9, 0.9, info.oppacity)
    love.graphics.rectangle("fill", ui:getX()-size, ui:getY()-size, ui:getWidth()+size*2, ui:getHeight()+size*2, 5, 5)
  end, true)

  system.render(cardHeld.ui.renderLayer-1, function ()
    love.graphics.setColor(1, 0.7, 0.3)
    love.graphics.setPointSize(6)
    local x1 = cardHeld.ui:getX()+cardHeld.ui:getWidth()/2
    local y1 = cardHeld.ui:getY()+cardHeld.ui:getHeight()/2
    local x2 = system.getStorage("realMouse").x
    local y2 = system.getStorage("realMouse").y
    local distance = utils.distanceBetween(x1, x2, y1, y2)
    local amount = math.floor(distance/20+0.5)
    local curveAmount = (system.getStorage("realMouse").x-640)/10
    drawDottedCurve(x1, y1, x2, y2, amount, curveAmount, info.dottedLineOffset)
  end, true)
end)