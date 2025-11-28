local function clamp(x)
  if x > 0 then
    x = math.max(x, 5)
  else
    x = math.min(-5, x)
  end
  return x
end

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

  local priceChange = changeAmount
  
  -- volatility
  local positivity = 1
  if changeAmount < 0 then
    positivity = -1
  end
  changeAmount = ((math.abs(changeAmount)+1) * (chart.volatility+1)-1) * positivity
  -- print(chart.bullPower, chart.bearPower, chart.volatility, changeAmount)

  local basicFactor = system.getStorage("main:basicChangeFactor") or 100
  changeAmount = changeAmount * basicFactor

  chart.volatility = chart.volatility^(7/8)

  chart.bullPower = chart.bullPower-(priceChange/trendSlowdown)
  chart.bearPower = chart.bearPower+(priceChange/trendSlowdown)

  chart.bullPower = math.max(0, chart.bullPower)
  chart.bearPower = math.max(0, chart.bearPower)

  changeAmount = math.floor(changeAmount+0.5)

  return changeAmount
end

function main.spawnBarChangeNews()
  local chart = system.getStorage("main:chart")
  if chart then
    local pos = chart:getCurrentPricePos()

    if pos == nil then
      return
    end

    local xoffset = love.math.random(-40, 40)
    local yoffset = love.math.random(-40, 40)

    local change = getChange()
    local name
    if change > 0 then
      name = "goodNews"
    else
      name = "badNews"
    end
    local n = main.spawnNews(name, {x=pos.x+xoffset, y=pos.y+yoffset, defaultPriceGain=clamp(change), temporary=2})
  end
end

-- system.on("main:endTurn", function ()
--   main.spawnBarChangeNews()
-- end)