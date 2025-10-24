-- only can click the latest one
local levels = {{x=-32, y=-32}}
local activeUI = {}

local pointsRequired = {
  80,
  150,
  300,
  600,
  1000
}

local function getPointRequirement(i)
  return pointsRequired[i] or math.floor(20*(1.5^i)+0.5)
end

main.defineScene("levelSelect", function ()
  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local isLast = false
    if i == #levels then
      isLast = true
    end
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y, isLastLevel=isLast}, true)
    activeUI[i] = ui
    ui.name = "Level " .. i
    ui.pointRequirement = getPointRequirement(i)
    ui.description = "Point Required: {pointColor}" .. ui.pointRequirement .. "{/pointColor}\nGives {moneyColor}$3"
    main.updateRichTextText(ui.richtext, i)
  end
  local lastUI = activeUI[#activeUI]
  system.updateStorage("main:pointRequirement", lastUI.pointRequirement)
  main.tweenCamera(0.2, {
    x=lastUI.x+lastUI.width/2,
    y=lastUI.y+lastUI.height/2})
  
  local chart = system.getStorage("main:chart")
  if chart then
    chart:forAllNews(function (news)
      news.ui.isVisible = false
    end)

    chart:forAllBar(function (bar)
      bar.isVisible = false
    end)
  end
end, function ()
  system.updateStorage("main:currentLevel", #levels)
  
  for i, ui in ipairs(activeUI) do
    ui:delete()
  end
  activeUI = {}
  local lastLevel = levels[#levels]
  local xAdd = 150
  local yAdd = love.math.random(-100, 100)
  table.insert(levels, {x=lastLevel.x+xAdd, y=lastLevel.y+yAdd})

  local chart = system.getStorage("main:chart")
  if chart then
    chart:forAllNews(function (news)
      news.ui.isVisible = true
    end)

    chart:forAllBar(function (bar)
      bar.isVisible = true
    end)
  end
end)