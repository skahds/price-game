-- system.on("@update", function ()
--   local mouse = system.getStorage("mouse")
--   local x, y = main.grid.toGrid(mouse.x, mouse.y)
--   if main.grid.getNewsInGrid(x, y, 1, 1) then
--     print("CAUGHT")
--   end
-- end)

local flux = system.getStorage("flux")
local pos = {x=0, y=0}

system.on("@update", function ()
  local mouse = system.getStorage("mouse")
  local x, y = main.grid.snapToGrid(mouse.x, mouse.y)
  local x, y = main.grid.getClosestAvailableGrid(x, y, 1, 1)
  local x, y = main.grid.gridToPos(x, y)
  flux.to(pos, 0.05, {x=x, y=y})
end)

local function drawTargetSize(news, x, y)
  local xOffsset, yOffset = main.grid.gridSize*news.target.shape.w, main.grid.gridSize*news.target.shape.h
  local wOffset, hOffset = (news.width or main.grid.gridSize)/2, (news.height or main.grid.gridSize)/2
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

system.on("@draw", function ()
  local cardHeld = system.getStorage("main:currentSelectedCard")
  if cardHeld == nil then
    return
  end

  if cardHeld.spawnNews == nil then
    return
  end

  local news = main.entities[cardHeld.spawnNews].definition

  system.render(280, function ()
    if news.target then
      drawTargetSize(news, pos.x, pos.y)
    end

    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(system.getImage(news.image), pos.x, pos.y)
  end)
end)