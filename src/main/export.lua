main.world = {}
main.deleteQueue = {}

function main.spawnEntity(id, args, ret)
  table.insert(main.world, main.entities[id]:new(args))
  main.world[#main.world].index = #main.world

  if ret then
    return main.world[#main.world]
  end
end

function main.spawnChart(args)
  local chart = main.spawnEntity("chart", args, true)
  system.updateStorage("chart", chart)
end

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
  chart.bearPower = math.min(1, math.max(0, chart.bearPower))

  print(chart.bullPower, chart.bearPower, changePIP)
  
  bar:changePricePIP(changePIP)
end

function main.spawnBar()
  local chart = system.getStorage("chart")
  local bar = main.spawnEntity("bar", {}, true)
  if chart then
    chart:addBar(bar)
    basicBarSpawnChange(bar, chart)
  end
  return bar
end