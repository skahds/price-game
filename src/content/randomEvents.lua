-- local newsList = {}

-- system.on("main:endTurn", function ()
--   -- random news?
  
--   local news = newsList[love.math.random(#newsList)]
--   local chart = system.getStorage("main:chart")
--   if chart and news then
--     local pos = chart:getCurrentPricePos()

--     local xoffset = pos.width
--     local yoffset
--     if pos.direction == 1 then
--       yoffset = pos.height - love.math.random(0, 60)
--     else
--       yoffset = -love.math.random(0, 60)
--     end

--     main.spawnNews(news, {x=pos.x+xoffset, y=pos.y+yoffset})
--   end
-- end)