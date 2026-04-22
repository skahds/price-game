-- this contains the chart, bar
-- chart ent
main.entities.chart = class(main.entities.basicEnt)
local chart = main.entities.chart
local basicEnt = main.entities.basicEnt

function chart:init(args)
  basicEnt.init(self, args)
  self.bars = self.bars or {}
  self.news = self.news or {}

  -- bull power is a number from 0-inf, ex: 0.5 means 50% chance of increase
  self.bullPower = self.bullPower or 0
  -- bear power is a number from 0-inf, ex: 0.5 means 50% chance of reduction
  self.bearPower = self.bearPower or 0
  -- trend is a number from -inf to inf, ex: 0.3 means 30% min and max chance increase
  self.trend = self.trend or 0
  -- volatility is a number from 0-inf, ex: 0.3 means change^1.3
  self.volatility = self.volatility or 0
  self.price = self.price or 0
end

--It looks terrible
-- function chart:draw()
--   local cam = main.getCamera()
--   local zoom = cam and cam.zoom or 1
--   local gridSize = (main.grid and main.grid.gridSize) or 32

--   -- when zoom < 1, increase spacing; snap to multiples of gridSize
--   local multiplier = 1
--   if zoom < 1 then
--     multiplier = math.max(1, math.floor(1 / zoom^4))
--   end
--   local step = gridSize * multiplier
--   print(multiplier, step)

--   local screen = system.getStorage("screenDimension") or {w=1280, h=720}
--   local halfW = (screen.w / 2) / zoom
--   local halfH = (screen.h / 2) / zoom

--   local minY = cam.y - halfH
--   local maxY = cam.y + halfH

--   local startLine = math.floor(minY / step) - 1
--   local endLine = math.ceil(maxY / step) + 1

--   system.render(2, function ()
--     love.graphics.setColor(1, 1, 1, 0.12)
--     love.graphics.setLineWidth(1)
--     local left = cam.x - halfW - 1000
--     local right = cam.x + halfW + 1000
--     for i = startLine, endLine do
--       local y = i * step
--       love.graphics.line(left, y, right, y)
--     end
--   end)
-- end

function chart:addBar(bar)
  self.bars[#self.bars+1] = bar
  bar.barOrder = #self.bars
  bar.x = bar.barOrder * bar.defaultWidth * 1.1
  if self:getBar(bar.barOrder-1) then
    local lastbar = self:getBar(bar.barOrder-1)
    bar.y = lastbar.y+lastbar.height
  else
    bar.y = 0
  end
end

function chart:getBar(index)
  if index < 0 then
    -- why do i even need to do this?
    index = #self.bars+index+1
  end
  return self.bars[index]
end

function chart:forAllBar(fun)
  for i, bar in ipairs(self.bars) do
    fun(bar)
  end
end

function chart:getNewsAmount()
  return #self.news
end

function chart:getNews(index)
  if index < 0 then
    -- negative index.. for some reason- why do i even need this
    index = #self.news+index+1
  end
  return self.news[index]
end

function chart:forAllNews(fun)
  for i, news in ipairs(self.news) do
    fun(news)
  end
end

function chart:addNews(news)
  table.insert(self.news, news)
end

function chart:removeNews(index)
  if #self.news < 1 then
    print("news empty")
    return
  end

  table.remove(self.news, index)

  for i, news in ipairs(self.news) do
    news.chartOrder = i
  end
end

function chart:getCurrentPricePos()
  local bar = self:getBar(-1)
  if bar then
    -- check if it goes up or down
    local direction = 1
    if bar.endPrice < bar.startPrice then
      direction = -1
    end

    local height = -(chart:priceToYPos(bar.endPrice)-chart:priceToYPos(bar.startPrice))
    local y = chart:priceToYPos(-bar.startPrice)

    return {x=bar.x,y=y+height, direction = direction, width=bar.width, height=height}
  else
    return {x=0, y=0, direction=1, width=40, height=0}
  end
end

function chart:priceToYPos(price)
  local sliderScale = system.getStorage("main:priceYScale")
  if sliderScale then
    sliderScale = 2^(sliderScale*4)
  end
  local yScale = sliderScale or 10
  yScale = yScale / 5
  return price*yScale
end

function chart:update()

end

-- function chart:delete()
--   self:forAllBar(function (bar)
--     bar:delete()
--   end)

--   for i=#self.news, 1, -1 do
--     local news = self.news[1]
--     if system.ask("main:shouldNewsNotBeDeleted", combiner.OR, news) ~= true then
--       main.deleteNews(news)
--     end
--   end

--   basicEnt.delete(self)
-- end

function chart:clear()
  self:forAllBar(function (bar)
    bar:delete()
  end)
  self.bars = {}
  self.price = 0

  for i=#self.news, 1, -1 do
    local news = self.news[i]
    if system.ask("main:shouldNewsNotBeDeleted", combiner.OR, news) ~= true then
      main.deleteNews(news)
    end
  end
end

--bar ent
main.entities.bar = class(main.entities.basicEnt)
local bar = main.entities.bar
function bar:init(args)
  self.defaultWidth = 40
  self.defaultHeight = 0
  self.renderLayer = 9
  self.outline=5

  local currentChart = system.getStorage("main:chart")
  local price = currentChart.price
  self.startPrice = price
  self.endPrice = price

  system.updateStorage("main:currentBar", self)
  basicEnt.init(self, args)
end

function bar:getX()
  return self.x
end
function bar:getY()
  return self.y
end
function bar:getWidth()
  return self.width or self.defaultWidth
end
function bar:getHeight()
  return self.height or self.defaultHeight
end

function bar:update()
  local height = -(chart:priceToYPos(self.endPrice)-chart:priceToYPos(self.startPrice))
  local flux = system.getStorage("flux")
  self.tweenHeight = flux.to(self, 0.2, {height = height})
  self.y = chart:priceToYPos(-self.startPrice)


  if self.startPrice < self.endPrice then
    self.color = {0.2, 0.7, 0.2}
  else
    self.color = {0.7, 0.2, 0.2}
  end
end

function bar:draw()
  local renderLayer = self.renderLayer

  system.render(renderLayer, function ()
    if self.color then
      love.graphics.setColor(self.color)
    else
      love.graphics.setColor(1, 1, 1)
    end

    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    if self.outline and self.height ~= 0 then
      local color = {
        self.color[1]*1.2,
        self.color[2]*1.2,
        self.color[3]*1.2,
      }
      love.graphics.setColor(color)
      love.graphics.setLineWidth(self.outline)
      love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    end
  end)
end

function bar:changePricePIP(pip)
  -- self.height = self.height - pip*100
  -- self.endPrice = 
  local chart = system.getStorage("main:chart")
  if chart then

    local price = chart.price
    local change = price*pip
    price = price + change
    self.endPrice = price
    
    chart.price = price

    system.call("main:currentPriceChanged", change)
  end
end

function bar:changePrice(amount)
  local chart = system.getStorage("main:chart")
  if chart then

    local price = chart.price
    local change = amount
    price = price + change
    self.endPrice = price
    
    chart.price = price

    system.call("main:currentPriceChanged", change)
  end
end

function bar:checkCollide(area)
  local height = -(chart:priceToYPos(self.endPrice)-chart:priceToYPos(self.startPrice))
  local originalHeight = self.height
  self.height = height
  local didCollide = main.AABB_check(area, self)
  self.height = originalHeight
  if didCollide then
    return true
  else
    return false
  end
end


system.register("chart", 6, function ()
  local t = {}
  local chartTable = {}
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end

  for k, v in pairs(chart) do
    if type(v) ~= "function" and type(v) ~= "userdata" and type(v) ~= "table" then
      chartTable[k] = v
    end
  end
  t.chart = chartTable

  local bars = {}
  for i, bar in ipairs(chart.bars) do
    bars[i] = {}
    for k, v in pairs(bar) do
      if type(v) ~= "function" and type(v) ~= "userdata" and type(v) ~= "table" then
        bars[i][k] = v
      end
    end
  end
  t.bars = bars

  local newsTable = {}
  for i, news in ipairs(chart.news) do
    local v = main.getAllComponentsFromEntity(news)
    v.x, v.y = news.x, news.y
    table.insert(newsTable, v)
  end
  t.news = newsTable

  return t
end, function (t)
  local chart = system.getStorage("main:chart")
  
  if t == nil then
    return
  end
  
  if chart == nil then
    main.spawnChart({bearPower = 0.1, bullPower = 0.1})
  end

  local chart = system.getStorage("main:chart")

  chart:clear()
  chart:forAllNews(function (news)
    news:delete()
  end)

  for k, v in pairs(t.chart) do
    chart[k] = v
  end

  for i, t in ipairs(t.bars) do
    local bar = main.spawnEntity("bar", t)
    if chart then
      chart:addBar(bar)
    end
  end

  for k, v in ipairs(t.news) do
    local news = main.spawnNews(v.id, v)
    news.ui.isVisible = false
  end
end)