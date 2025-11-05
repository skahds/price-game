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

system.on("@draw", function ()
  local cardHeld = system.getStorage("main:currentSelectedCard")
  if cardHeld == nil then
    return
  end

  if cardHeld.spawnNews == nil then
    return
  end

  local news = main.entities[cardHeld.spawnNews].definition

  system.render(299, function ()
    love.graphics.setColor(1, 1, 1, 0.8)
    love.graphics.draw(system.getImage(news.image), pos.x, pos.y)
  end)
end)