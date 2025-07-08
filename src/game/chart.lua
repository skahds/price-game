-- this contains the chart and bar entities
-- chart ent
main.entities.chart = class(main.entities.basicEnt)
local chart = main.entities.chart
local basicEnt = main.entities.basicEnt

function chart:init(args)
  basicEnt.init(self, args)
  self.bars = self.bars or {}

  -- bull power is a number from 0-inf, ex: 0.5 means 50% increase
  self.bullPower = self.bullPower or 0
  -- bear power is a number from 0-1, ex: 0.5 means 50% reduction
  self.bearPower = self.bearPower or 0
  -- trend is a number from -1 - inf, ex: 0.3 means 30% min and max increase
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
  return self.bars[index]
end

function chart:forAllBar(fun)
  for i, bar in ipairs(self.bars) do
    fun(bar)
  end
end

function chart:priceToYPos(price)
  return price*10
end

function chart:update()

end

function chart:draw()
  system.render(10, function ()
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    for i=1, 500 do
      local pricePerLine = (i-250)*2
      local y = self:priceToYPos(pricePerLine)
      love.graphics.line(-10000, y, 10000, y)
    end
  end)
end



--bar ent
main.entities.bar = class(main.entities.basicEnt)
local bar = main.entities.bar
function bar:init(args)
  self.defaultWidth = 10
  self.defaultHeight = 0
  self.renderLayer = 1

  local currentChart = system.getStorage("main:chart")
  local price = currentChart.price
  self.startPrice = price

  basicEnt.init(self, args)
end

function bar:update()
  
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
    
    local height = -chart:priceToYPos(change)
    
    local flux = system.getStorage("flux")
    self.tweenHeight = flux.to(self, 0.2, {height = height})

    system.call("main:currentPriceChanged", self)
  end

  if self.startPrice < self.endPrice then
    self.color = {0.2, 0.7, 0.2}
  else
    self.color = {0.7, 0.2, 0.2}
  end
end