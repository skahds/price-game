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
  -- bear power is a number from 0-1, ex: 0.5 means 50% chance of reduction
  self.bearPower = self.bearPower or 0
  -- trend is a number from -1 - inf, ex: 0.3 means 30% min and max chance increase
  self.trend = self.trend or 0
  -- volatility is a number from 0-inf, ex: 0.3 means change^1.3
  self.volatility = self.volatility or 0
  self.price = self.price or 10
end

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

  print("removed news")

  for i=#self.news, index, -1 do
    local news = self.news[i]
    news.chartOrder = news.chartOrder-1
  end

  print("deleting index" .. index .. " with remain " .. #self.news)
  table.remove(self.news, index)
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
  yScale = yScale * 5
  return price*yScale + 10*yScale
end

function chart:update()

end

function chart:draw()
  -- system.render(10, function ()
  --   love.graphics.setLineWidth(1)
  --   love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
  --   for i=1, 500 do
  --     local pricePerLine = (i-250)*2
  --     local y = self:priceToYPos(pricePerLine)
  --     love.graphics.line(-10000, y, 10000, y)
  --   end
  -- end)
end

function chart:delete()
  self:forAllBar(function (bar)
    bar:delete()
  end)

  self:forAllNews(function (news)
    news:delete()
  end)

  basicEnt.delete(self)
end



--bar ent
main.entities.bar = class(main.entities.basicEnt)
local bar = main.entities.bar
function bar:init(args)
  self.defaultWidth = 40
  self.defaultHeight = 0
  self.renderLayer = 1

  local currentChart = system.getStorage("main:chart")
  local price = currentChart.price
  self.startPrice = price

  basicEnt.init(self, args)
end

function bar:update()
  local height = -(chart:priceToYPos(self.endPrice)-chart:priceToYPos(self.startPrice))
  local flux = system.getStorage("flux")
  self.tweenHeight = flux.to(self, 0.2, {height = height})
  self.y = chart:priceToYPos(-self.startPrice)
end

function bar:draw()
  basicEnt.draw(self)
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

    system.call("main:currentPriceChanged", self)
  end

  if self.startPrice < self.endPrice then
    self.color = {0.2, 0.7, 0.2}
  else
    self.color = {0.7, 0.2, 0.2}
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

    system.call("main:currentPriceChanged", self)
  end

  if self.startPrice < self.endPrice then
    self.color = {0.2, 0.7, 0.2}
  else
    self.color = {0.7, 0.2, 0.2}
  end
end

function bar:checkCollide(ent)
  local height = -(chart:priceToYPos(self.endPrice)-chart:priceToYPos(self.startPrice))
  local originalHeight = self.height
  self.height = height
  local didCollide = main.AABB_check(ent, self)
  self.height = originalHeight
  if didCollide then
    return true
  else
    return false
  end
end