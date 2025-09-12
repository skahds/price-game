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

function main.basicBarSpawnChange(bar, chart)
  local trendSlowdown = 3
  local bigNum = 1000000
  local changeAmount = love.math.random(
  -(chart.bearPower+chart.trend)*bigNum,
  (chart.bullPower+chart.trend)*bigNum
  )/bigNum

  
  local pointChange = changeAmount
  
  -- volatility
  local positivity = 1
  if changeAmount < 0 then
    positivity = -1
  end
  changeAmount = ((math.abs(changeAmount)+1) * (chart.volatility+1)-1) * positivity
  print(chart.bullPower, chart.bearPower, chart.volatility, changeAmount)

  local basicFactor = system.getStorage("main:basicChangeFactor") or 100
  changeAmount = changeAmount * basicFactor

  chart.volatility = chart.volatility^(7/8)

  chart.bullPower = chart.bullPower-(pointChange/trendSlowdown)
  chart.bearPower = chart.bearPower+(pointChange/trendSlowdown)

  chart.bullPower = math.max(0, chart.bullPower)
  chart.bearPower = math.max(0, chart.bearPower)

  bar:changePrice(changeAmount)
end

function main.spawnBar()
  local chart = system.getStorage("main:chart")
  local bar = main.spawnEntity("bar", {}, true)
  if chart then
    chart:addBar(bar)
    -- bar:changePrice(0)
  end
  return bar
end

-- pretty hacky.. this is more of a "helper" function
function main.deleteEntity(ent)
  if ent.isCard then
    main.deleteCard(ent)
  elseif ent.isNews then
    main.deleteNews(ent)
  end
end

function main.addPoint(amount)
  local bar = system.getStorage("main:currentBar")
  if bar then
    bar:changePrice(amount)
  end
end

function main.addMult(amount)
  local mult = system.getStorage("main:mult")
  mult = mult + amount
  system.updateStorage("main:mult", mult)
  system.call("main:multChanged", mult)
end