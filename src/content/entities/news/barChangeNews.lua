local function getChange()
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end
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

  changeAmount = math.floor(changeAmount+0.5)

  return changeAmount
end

local function getMinMax()
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end
  local min = -(chart.bearPower+chart.trend)
  local max = (chart.bullPower+chart.trend)

  
  -- volatility
  min = ((math.abs(min)+1) * (chart.volatility+1)-1) * -1
  max = ((math.abs(max)+1) * (chart.volatility+1)-1) * 1

  local basicFactor = system.getStorage("main:basicChangeFactor") or 100
  min, max = min * basicFactor, max * basicFactor

  min, max = math.floor(min+0.5), math.floor(max+0.5)

  return min, max
end

main.defineNews("randomNews", {
  name = "Random movement",
  image = "randomNews",
  trigger = {"ROUND"},
  description = ".",
  temporary = 1,
  onActivate = function ()
    local change = getChange()
    main.addPoint(change)
  end
})

system.on("main:endTurn", function ()
  local chart = system.getStorage("main:chart")
  if chart then
    local pos = chart:getCurrentPricePos()

    local xoffset = pos.width
    local yoffset
    if pos.direction == 1 then
      yoffset = pos.height - love.math.random(0, 60)
    else
      yoffset = -love.math.random(0, 60)
    end

    local n = main.spawnNews("randomNews", {x=pos.x+xoffset, y=pos.y+yoffset, temporary=1})
    local min, max = getMinMax()
    n.description = "Gives {pointColor}points{/pointColor} between {pointColor}" .. min .. "{/pointColor} and {pointColor}" .. max
  end
end)