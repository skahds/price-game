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

local function basicBarSpawnChange(bar, chart)
  local trendSlowdown = 3
  local bigNum = 1000000
  local changeAmount = love.math.random(
  -(chart.bearPower+chart.trend)*bigNum,
  (chart.bullPower+chart.trend)*bigNum
  )/bigNum
  -- if changeAmount == 0 then
  --   changeAmount = 0.01
  -- end

  local basicFactor = system.getStorage("main:basicChangeFactor") or 10
  local pointChange = changeAmount
  changeAmount = changeAmount * basicFactor
  
  --balances bear with bulls
  -- local softenFactor = 0.5
  -- if changeAmount < 0 then
  --   changeAmount = changeAmount*softenFactor
  -- end

  -- volatility
  changeAmount = ((changeAmount) * (1+chart.volatility))
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
    basicBarSpawnChange(bar, chart)
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