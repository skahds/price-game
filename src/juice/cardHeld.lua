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

local info={oppacity=1}

system.on("@draw", function ()
  local cardHeld = system.getStorage("main:currentSelectedCard")
  if cardHeld == nil then
    info.oppacity=1
    return
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
end)