local flux = system.getStorage("flux")

local levels = {}
local activeUI = {}
-- routes: "PLAY", "SHOP"
local route = {
  {id="PLAY", node=1, reward={4}},
  {id="PLAY", node=2},
  {id="SHOP", node=1},
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=1},
  {id="PLAY", node=1},
}
local currentRoute = 1
system.updateStorage("main:currentRoute", 1)

local levelSelectSize = 64

local scoreRequired = {
  200,
  300,
  500,
  800,
  1000
}

local function getscoreRequirement(i, difficulty)
  local s = scoreRequired[i] or math.floor(20*(1.5^i)+0.5)
  s = math.floor(s * (1+difficulty)/20)*10
  return s
end

local function clamp(n)
  if n > 0 then
    return math.max(110, n)
  else
    return math.min(-110, n)
  end
end

local function generateLevelMap(amount)
  local xo, yo = clamp(love.math.random(-140, 140)), clamp(love.math.random(-140, 140))
  
  for i=1, amount do
    table.insert(levels, {x=xo-levelSelectSize/2, y=yo-levelSelectSize/2})
    xo, yo = utils.rotatePoint(xo, yo, 360/amount, 0, 0)
    xo=clamp(xo+love.math.random(-20, 20))
    yo=clamp(yo+love.math.random(-20, 20))
  end
end

local rewardList = {
  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({rarity="COMMON", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {commonColor}COMMON{/commonColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({rarity="RARE", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {rareColor}RARE{/rareColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({rarity="EPIC", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {epicColor}EPIC{/epicColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomNewsWithInfo({amount=3})
    main.createRewardsOptions(t, {rewardType="news"})
  end,
  description="Choose a relic!"},
}

local function generateReward(difficulty)
  local t
  if difficulty == 1 then
    t = utils.deepCopy(rewardList[1])
  elseif difficulty == 2 then
    t = utils.deepCopy(rewardList[2])
  elseif difficulty == 3 then
    t = utils.deepCopy(rewardList[4])
  end
  t.difficulty = difficulty
  return t
end

system.on("@update", function ()
  currentRoute = system.getStorage("main:currentRoute")
end)

main.defineScene("levelSelect", function ()
  main.wait(0.1, function ()
    system.saveGame()
  end)
  
  generateLevelMap(route[currentRoute].node)

  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y, isLastLevel=isLast})
    if route[currentRoute].id == "PLAY" then
      local difficulty = i
      activeUI[i] = ui
      if route[currentRoute].reward and route[currentRoute].reward[i] then
        ui.reward=utils.deepCopy(rewardList[route[currentRoute].reward[i]])
        ui.reward.difficulty=i
      else
        ui.reward = generateReward(difficulty)
      end
      ui.name = "Difficulty: " .. ui.reward.difficulty
      ui.scoreRequirement = getscoreRequirement(system.getStorage("main:currentDay"), difficulty)
      ui.moneyReward = 2+difficulty
      ui.description = "Score Required: {priceColor}" .. ui.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. ui.moneyReward .. "\nRewards: " .. ui.reward.description
      main.updateRichTextText(ui.richtext, string.rep("I", ui.reward.difficulty))
    elseif route[currentRoute].id == "SHOP" then
      activeUI[i] = ui
      ui.name = "Shop"
      ui.description = "Buy items!"
      ui.targetScene = "shop"
      main.updateRichTextText(ui.richtext, "{moneyColor}$")
    end
  end

  main.tweenCamera(0.2, {x=0, y=0, zoom=1.2})

  if system.getStorage("main:isDoingTutorial") then
    if currentRoute == 1 then
      main.addEntityToTutorial(activeUI[1], "Click here to begin\nyour encounter!")
    end
  end

  local chart = system.getStorage("main:chart")
  if chart == nil then
    main.spawnChart({bearPower = 0.1, bullPower = 0.1})
    chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()

    local bar = main.spawnBar()
  end
  
  main.hideCharts()
end, function ()
  if system.getStorage("main:isDoingTutorial") then
    main.clearTutorial()
  end

  for i, ui in ipairs(activeUI) do
    ui:delete()
  end
  activeUI = {}
  levels = {}
end)

--juice
local scale={s=1}

local function scaleChange()
  flux.to(scale, 5, {s=1.1}):ease("linear")
  main.wait(5, function ()
    flux.to(scale, 5, {s=0.9}):ease("linear")
    main.wait(5, function ()
      scaleChange()
    end)
  end)
end

scaleChange()

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "levelSelect" then
    return
  end

  system.render(3, function ()
    for i, ui in ipairs(activeUI) do
      love.graphics.setColor(1, 1, 1, 0.2)
      love.graphics.setLineWidth(4)
      love.graphics.line(ui:getX()+ui:getWidth()/2, ui:getY()+ui:getHeight()/2, 0, 0)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(system.getImage("baseNetwork"), 0, 0, 0, scale.s, scale.s, 48, 48)
  end, false)

  -- for i, ui in ipairs(activeUI) do

  --   if ui.moneyReward and ui.moneyReward ~= 0 then
  --     local t = main.printRichText({
  --       format="{moneyColor}$" .. ui.moneyReward,
  --       x=ui:getX()+ui:getWidth()/2,
  --       y=ui:getY()+ui:getHeight()-20,
  --       screenSpace = false,
  --       renderLayer = ui.renderLayer+1
  --       })
  --     t.x = t.x - t.richText:getWidth()/2
  --   end
  -- end

  local t = main.printRichText({
    format="DAY: " .. system.getStorage("main:currentDay") .. "/5",
    x=640,
    y=20,
    screenSpace = true,
    renderLayer = 6,
    font=system.getFont("defaultFont80")
    })
  t.x = t.x - t.richText:getWidth()/2
end)