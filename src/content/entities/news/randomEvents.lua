local newsList = {"goodNews", "badNews"}

main.defineNews("randomEvents", {
  name = "Random Events",
  image = "randomEventNews",
  width = 64,
  height = 64,
  description = "Creates a random event",
  trigger = {"EACHTURN"},
  isRelic = true,
  onActivate = function (ent)
    
    local news = newsList[love.math.random(#newsList)]
    local chart = system.getStorage("main:chart")
    if chart and news then
      local pos = chart:getCurrentPricePos()

      local xoffset = pos.width
      local yoffset
      if pos.direction == 1 then
        yoffset = pos.height - love.math.random(0, 40)
      else
        yoffset = -love.math.random(0, 40)
      end

      main.spawnNews(news, {x=pos.x+xoffset, y=pos.y+yoffset})
    end
  end,
})