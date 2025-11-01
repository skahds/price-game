local levels = {}
local activeUI = {}

local levelSelectSize = 64

local scoreRequired = {
  80,
  150,
  300,
  600,
  1000
}

local function getscoreRequirement(i)
  return scoreRequired[i] or math.floor(20*(1.5^i)+0.5)
end

local function clamp(n)
  if n > 0 then
    return math.max(90, n)
  else
    return math.min(-90, n)
  end
end

local function generateLevelMap(amount)
  local xo, yo = clamp(love.math.random(-140, 140)), clamp(love.math.random(-140, 140))
  
  for i=1, amount do
    table.insert(levels, {x=xo-levelSelectSize/2, y=yo-levelSelectSize/2})
    xo, yo = utils.rotatePoint(xo, yo, 360/amount, 0, 0)
    xo=xo+love.math.random(-20, 20)
    yo=yo+love.math.random(-20, 20)
  end
end

local rewardList = {
  {claim=function ()
    local t = {}
    local bag = system.getStorage("rarity:bag")
    for i=1, 3 do
      table.insert(t, bag:getRandomCardWithRarity("EPIC"))
    end
    main.createRewardsOptions(t)
  end,
  description="Gives random cards"}
}

local function generateReward()
  local t=utils.deepCopy(rewardList[1])
  return t
end

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "levelSelect" then
    return
  end

  system.render(5, function ()
    for i, ui in ipairs(activeUI) do
      love.graphics.setColor(1, 1, 1, 0.2)
      love.graphics.setLineWidth(4)
      love.graphics.line(ui:getX()+ui:getWidth()/2, ui:getY()+ui:getHeight()/2, 0, 0)
    end
  end, false)

  for i, ui in ipairs(activeUI) do

    if ui.moneyReward and ui.moneyReward ~= 0 then
      local t = main.printRichText({
        format="{moneyColor}$" .. ui.moneyReward,
        x=ui:getX()+ui:getWidth()/2,
        y=ui:getY()+ui:getHeight()-20,
        screenSpace = false,
        renderLayer = 5
        })
      t.x = t.x - t.richText:getWidth()/2
    end
  end

  local t = main.printRichText({
    format="DAY: " .. system.getStorage("main:currentDay") .. "/5",
    x=640,
    y=20,
    screenSpace = true,
    renderLayer = 6,
    font=system.getFont("defaultFont80")
    })
  t.x = t.x - t.richText:getWidth()/2

  local t = main.printRichText({
    format="Pick an encounter!",
    x=640,
    y=80,
    screenSpace = true,
    renderLayer = 6,
    font=system.getFont("defaultFont80")
    })
  t.x = t.x - t.richText:getWidth()/2
end)

main.defineScene("levelSelect", function ()
  generateLevelMap(3)
  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y, isLastLevel=isLast}, true)
    activeUI[i] = ui
    ui.name = "Level " .. i
    ui.scoreRequirement = getscoreRequirement(i)
    ui.moneyReward = 3
    ui.reward = generateReward()
    ui.description = "Score Required: {priceColor}" .. ui.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. ui.moneyReward .. "\nRewards: " .. ui.reward.description
    main.updateRichTextText(ui.richtext, "$")
  end
  
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
  
  for i, ui in ipairs(activeUI) do
    ui:delete()
  end
  activeUI = {}
  levels = {}

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