local flux = system.getStorage("flux")

local levels = {}
local activeUI = {}
-- routes: "PLAY", "SHOP"
local route
local currentRoute = 1
system.updateStorage("main:currentRoute", 1)

local levelSelectSize = 64
local scoreRequired

local basicRoute = {
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=1},
}

local basicScoreRequired = {
  200,
  300,
  400,
  550,
  700,
  1000,
  2000
}

local function getscoreRequirement(i, difficulty)
  local s
  if scoreRequired then
    s = scoreRequired[i] or math.floor(20*(1.5^i)+0.5)
  else
    s = basicScoreRequired[i] or math.floor(20*(1.5^i)+0.5)
  end

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
    local t = bag:getRandomCardWithInfo({minimumRarity="COMMON", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {commonColor}COMMON+{/commonColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="RARE", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose a {rareColor}RARE+{/rareColor} card!"},

  {claim=function ()
    local bag = system.getStorage("rarity:bag")
    local t = bag:getRandomCardWithInfo({minimumRarity="EPIC", amount=3})
    main.createRewardsOptions(t, {rewardType="card"})
  end,
  description="Choose an {epicColor}EPIC+{/epicColor} card!"},

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
  else
    t = t.utils.deepCopy(rewardList[1])
  end
  t.difficulty = difficulty
  return t
end

local firstName = {"XYZ", "Hyper", "Prime", "Quantum", "Zenith", "Clockwork", "Stasis", "Solar", "Lunar", "Elysian", "Aether", "Sigma", "Alpha"}
local lastName = {"network", "market", "exchange", "grid", "nexus", "artery", "chain", "protocol", "platform", "route", "link", "community"}
local function generateNodeName()
  local front = firstName[love.math.random(1, #firstName)]
  local last = lastName[love.math.random(1, #lastName)]
  return front .. " " .. last
end

system.on("@update", function ()
  route = system.getStorage("main:route")
  currentRoute = system.getStorage("main:currentRoute") or 1
  scoreRequired =  system.getStorage("main:scoreRequirementList")
end)

main.defineScene("levelSelect", function ()
  main.wait(0.1, function ()
    system.saveGame()
  end)
  
  local route = route or basicRoute

  generateLevelMap(route[currentRoute].node)
  if system.getStorage("main:isDoingTutorial") and currentRoute == 1 then
    levels[1].x = 150
    levels[1].y = -100
  end

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
      ui.name = generateNodeName()
      ui.scoreRequirement = getscoreRequirement(system.getStorage("main:currentDay"), difficulty)
      ui.moneyReward = 2+difficulty
      ui.description = "Score Required: {priceColor}" .. ui.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. ui.moneyReward .. "\nRewards: " .. ui.reward.description
      if route[currentRoute].enemy then
        local e
        if route[currentRoute].enemy then e = route[currentRoute].enemy end
        ui.enemy = main.enemies.entities[e] or main.enemies.getRandomEnemy()
        ui.description = ui.description .. "\nhas Enemy: " .. ui.enemy.name
        ui.descriptionTagEntity = ui.enemy.id
      end
      local color = ""
      if ui.reward.difficulty == 2 then
        color = "{rareColor}"
      elseif ui.reward.difficulty == 3 then
        color = "{epicColor}"
      end
      main.updateRichTextText(ui.richtext, color .. string.rep("!", ui.reward.difficulty))
    elseif route[currentRoute].id == "SHOP" then
      activeUI[i] = ui
      if i == 1 then
        ui.name = "Shop"
        ui.description = "Buy items!"
        ui.targetScene = "shop"
        main.updateRichTextText(ui.richtext, "{moneyColor}$")
      elseif i == 2 then
        ui.name = "Treasure"
        ui.description = "Get a relic!"
        ui.targetScene = "treasureRoom"
        main.updateRichTextText(ui.richtext, "{redColor}$")
      end
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

  for i, ui in ipairs(activeUI) do

    if ui and ui.name then
      local t = main.printRichText({
        format=ui.name,
        x=ui:getX()+ui:getWidth()/2,
        y=ui:getY(),
        screenSpace = false,
        renderLayer = ui.renderLayer+1,
        font=system.getFont("defaultFont30")
        })
      t.x = t.x - t.richText:getWidth()/2
      t.y = t.y - t.richText:getHeight()
    end
  end

  local amountOfDay = 0
  for i, t in ipairs(route) do
    if t.id == "PLAY" then
      amountOfDay = amountOfDay + 1
    end
  end
  
  local t = main.printRichText({
    format="DAY: " .. system.getStorage("main:currentDay") .. "/" .. amountOfDay,
    x=640,
    y=20,
    screenSpace = true,
    renderLayer = 6,
    font=system.getFont("defaultFont80")
    })
  t.x = t.x - t.richText:getWidth()/2
end)