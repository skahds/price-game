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
  local trendSlowdown = 10
  local bigNum = 1000000
  local changePIP = love.math.random(
  -(chart.bearPower+chart.trend)*bigNum,
  (chart.bullPower+chart.trend)*bigNum
  )/bigNum
  
  changePIP = changePIP ^ (1+chart.volatility)

  chart.bullPower = chart.bullPower-(changePIP/trendSlowdown)
  chart.bearPower = chart.bearPower+(changePIP/trendSlowdown)
  print(chart.bullPower, chart.bearPower, changePIP)
  
  bar:changePrice(changePIP)
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