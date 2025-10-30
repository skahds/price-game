function main.spawnChart(args)
  local chart = main.spawnEntity("chart", args, true)
  system.updateStorage("main:chart", chart)
end

--[[
local function basicBarSpawnChange(bar, chart)
  local trendSlowdown = 3
  local bigNum = 1000000
  local changePIP = love.math.random(
  -(chart.bearPower+chart.trend)*bigNum,
  (chart.bullPower+chart.trend)*bigNum
  )/bigNum
  
  --balances bear with bulls
  local softenFactor = 0.5
  if changePIP < 0 then
    changePIP = changePIP*softenFactor
  end

  -- volatility
  changePIP = ((changePIP+1) ^ (1+chart.volatility))-1
  chart.volatility = chart.volatility^(7/8)

  chart.bullPower = chart.bullPower-(changePIP/trendSlowdown)
  chart.bearPower = chart.bearPower+(changePIP/trendSlowdown)

  chart.bullPower = math.max(0, chart.bullPower)
  chart.bearPower = math.max(0, chart.bearPower)

  print(chart.bullPower, chart.bearPower, changePIP)
  
  bar:changePricePIP(changePIP)
end
]]

function main.spawnBar()
  local chart = system.getStorage("main:chart")
  local bar = main.spawnEntity("bar", {}, true)
  if chart then
    chart:addBar(bar)
  end
  return bar
end

-- pretty hacky.. this is more of a "helper" function
function main.deleteEntity(ent)
  if ent.isCard then
    return main.deleteCard(ent)
  elseif ent.isNews then
    return main.deleteNews(ent)
  end
end

-- for cards to use, ie destroy card to the right
function main.tryDestroyEntity(ent)
  if ent.isCard then
    return main.deleteCard(ent)
  elseif ent.isNews then
    return main.deleteNews(ent)
  end
end

function main.getPrice()
  local bar = system.getStorage("main:currentBar")
  if bar then
    return bar.endPrice-bar.startPrice
  end
end

function main.addPrice(amount)
  local bar = system.getStorage("main:currentBar")
  if bar then
    bar:changePrice(amount)
  end
end

function main.addMult(amount)
  local mult = system.getStorage("main:mult")
  mult = mult + amount
  system.updateStorage("main:mult", mult)
  system.call("main:multChanged", amount)
end

function main.addEnergy(amount)
  local energy = system.getStorage("main:energy")
  energy = energy + amount
  system.updateStorage("main:energy", energy)
  system.call("main:energyChanged", amount)
end