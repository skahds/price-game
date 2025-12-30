local flux = system.getStorage("flux")

local levels = {}
local activeRouteUI = {}
-- routes: "PLAY", "SHOP"
local route
local currentRoute = 1
local currentCycle = 1

local existingUI = {}
local leftCoverX = 20
local coverWidth = 330
local rightCoverx = 1280-350

local levelSelectSize = 64
local scoreRequired

local function getscoreRequirement(i, difficulty)
  local s
  if scoreRequired and scoreRequired.cycles[currentCycle] then
    local mult = scoreRequired.changeInCycle
    if i == 4 then
      s = scoreRequired.cycles[currentCycle] * scoreRequired.bossScore
    else
      s = scoreRequired.cycles[currentCycle] * (1+mult*(i-1))
    end
  else
    error("unimplemented cycle " .. currentCycle)
  end

  s = math.floor(s * (1+(difficulty-1)*0.2)/10)*10
  s=s/100
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

  {claim=function ()
    main.createRewardsUpgrade()
  end,
  description="Upgrade a card!"},

  {money = 20},
}

local function pickRandom(t)
  return t[love.math.random(1, #t)]
end

local function generateReward(index)
  local t
  if #levels == 2 then
    if index == 1 then
      t = utils.deepCopy(pickRandom{rewardList[1], rewardList[2]})
    elseif index == 2 then
      t = utils.deepCopy(pickRandom{rewardList[3], rewardList[5], rewardList[6]})
    else
      t = t.utils.deepCopy(rewardList[1])
    end
  elseif #levels == 3 then
    if index == 1 then
      t = utils.deepCopy(rewardList[1])
    elseif index == 2 then
      t = utils.deepCopy(rewardList[2])
    elseif index == 3 then
      t = utils.deepCopy(pickRandom{rewardList[5], rewardList[6]})
    else
      t = t.utils.deepCopy(rewardList[1])
    end
  else
    t = t.utils.deepCopy(rewardList[1])
  end
  t.difficulty = index
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
  currentCycle = system.getStorage("main:currentCycle") or 1
  scoreRequired =  system.getStorage("main:scoreRequirementList")
end)




main.defineScene("levelSelect", function ()
  main.wait(0.1, function ()
    system.saveGame()
  end)

  table.insert(existingUI, main.ui.spawnUI("cover", {x=leftCoverX, y=70, width=330, height=580,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10}))

  table.insert(existingUI, main.ui.spawnUI("cover", {x=rightCoverx, y=70, width=330, height=580,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10}))

  local currentTrack = route[currentCycle][currentRoute] --todo fix

  local amountOfNode
  if type(currentTrack.node) == "table" then
    amountOfNode = currentTrack.node[love.math.random(1, #currentTrack.node)]
  else
    amountOfNode = currentTrack.node
  end

  generateLevelMap(amountOfNode)
  if system.getStorage("main:isDoingTutorial") and currentRoute == 1 and currentCycle == 1 then
    levels[1].x = 150
    levels[1].y = -100
  end

  local enemy
  if currentTrack.enemy then
    enemy = currentTrack.enemy[love.math.random(1, #currentTrack.enemy)]
  end

  --todo: change
  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y})
    if currentTrack.id == "PLAY" then
      local difficulty = i
      activeRouteUI[i] = ui
      if currentTrack.reward and currentTrack.reward[i] then
        ui.reward=utils.deepCopy(rewardList[currentTrack.reward[i]])
        ui.reward.difficulty=i
      else
        ui.reward = generateReward(difficulty)
      end
      ui.name = generateNodeName()
      ui.scoreRequirement = getscoreRequirement(system.getStorage("main:currentDay"), difficulty)
      ui.moneyReward = ui.reward.money or 3
      ui.description = "Score Required: {priceColor}" .. ui.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. ui.moneyReward
      if ui.reward.description then ui.description = ui.description .. "\nRewards: " .. ui.reward.description end
      if enemy then
        ui.enemy = main.enemies.getEnemy(enemy)
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
    elseif currentTrack.id == "SHOP" then
      activeRouteUI[i] = ui
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

  main.tweenCamera(0.2, {x=0, y=0, zoom=1})

  if system.getStorage("main:isDoingTutorial") then
    if currentRoute == 1 and currentCycle == 1 then
      main.addEntityToTutorial(activeRouteUI[1], "Click here to begin\nyour encounter!")
    end
  end
  
  --todo note for tmr: change all currentRoute and fix stuff

  main.hideCharts()
end, function ()
  if system.getStorage("main:isDoingTutorial") then
    main.clearTutorial()
  end

  for i, ui in ipairs(existingUI) do
    ui:delete()
  end

  for i, ui in ipairs(activeRouteUI) do
    ui:delete()
  end
  activeRouteUI = {}
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

local function concat(t1, t2)
  if t1 == "" then
    return t2
  else
    return t1 .. "-" .. t2
  end
end

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "levelSelect" then
    return
  end

  system.render(3, function ()
    for i, ui in ipairs(activeRouteUI) do
      love.graphics.setColor(1, 1, 1, 0.2)
      love.graphics.setLineWidth(4)
      love.graphics.line(ui:getX()+ui:getWidth()/2, ui:getY()+ui:getHeight()/2, 0, 0)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(system.getImage("baseNetwork"), 0, 0, 0, scale.s, scale.s, 48, 48)
  end, false)

  for i, ui in ipairs(activeRouteUI) do

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
  if route[currentCycle] then
    for i, t in ipairs(route[currentCycle]) do
      if t.id == "PLAY" then
        amountOfDay = amountOfDay + 1
      end
    end
  end
  local leftStats = {"CYCLE: " .. currentCycle, "DAY: " .. system.getStorage("main:currentDay") .. "/" .. amountOfDay}

  for i, stat in ipairs(leftStats) do
    local t = main.printRichText({
      format=stat,
      x=leftCoverX+coverWidth/2,
      y=100,
      screenSpace = true,
      renderLayer = 95,
      -- font=system.getFont("defaultFont80")
      })
    t.y = t.y + t.richText:getHeight() * (i-1)
    t.x = t.x - t.richText:getWidth()/2
  end

  local tracks = "" -- TODO: REMOVE THIS :SKULL: and change it with actual ui that spawns when the scene is loaded so that i can detect when it is hovered, i can give it an image, i can tween it's size etcetc

  for i, track in ipairs(route[currentCycle]) do
    if track.id == "PLAY" then
      tracks = concat(tracks, "X")
    elseif track.id == "SHOP" then
      tracks = concat(tracks, "$")
    end
  end

  local t = main.printRichText({
    format=tracks,
    x=leftCoverX+coverWidth/2,
    y=200,
    screenSpace = true,
    renderLayer = 95,
  })
  t.x = t.x - t.richText:getWidth()/2

end)