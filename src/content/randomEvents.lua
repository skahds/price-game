local newsList = {"goodNews", "badNews"}
local range = {1, 3}
local randomNewsCounter = love.math.random(range[1], range[2])
local currentCounter = 0

main.defineNews("randomEvents", {
  name = "Random Events",
  image = "randomEventNews",
  width = 64,
  height = 64,
  description = "Creates a random news\nin " .. randomNewsCounter .. " activation",
  trigger = {"ROUND"},
  isRelic = true,
  onActivate = function (ent)
    currentCounter = currentCounter + 1
    if currentCounter >= randomNewsCounter then
      currentCounter = 0
      randomNewsCounter = love.math.random(range[1], range[2])
    else
      return
    end

    ent.description = "Creates a random news in " .. randomNewsCounter .. " activation"
    
    local news = newsList[love.math.random(#newsList)]
    local chart = system.getStorage("main:chart")
    if chart and news then
      local pos = chart:getCurrentPricePos()

      local xoffset = pos.width
      local yoffset
      if pos.direction == 1 then
        yoffset = pos.height - love.math.random(0, 60)
      else
        yoffset = -love.math.random(0, 60)
      end

      main.spawnNews(news, {x=pos.x+xoffset, y=pos.y+yoffset})
    end
  end,
})