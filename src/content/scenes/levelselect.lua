local flux = system.getStorage("flux")

local levels = {}
local activeRouteUI = {}
local savedRouteUI
-- routes: "PLAY", "SHOP"
local route
local currentRoute = 1
local currentCycle = 1

local existingUI = {}
local leftCoverX = 60
local coverWidth = 330
local rightCoverx = 1280-350
local listOfTrackIndicator = {}
local currentNodeHovered = ""
local lastLevelHovered

local levelSelectSize = 64
local scoreRequired

local objectiveText
local objectiveCover

local enemyText
local enemyCover
local cycleBossInfo = {}
local enemyNews = {}
local usedEnemies = {}
local enemyTiers = {normal=1, elite=2, boss=3}

--
--level select things
--
local function deleteAll(args)
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

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
  -- s=s/100
  return s
end

local function generateLevelMap(amount)
  local radius = 180  -- adjust as needed

  for i=1, amount do
    local baseAngle = (2 * math.pi / amount) * (i - 1)
    local jitter = (love.math.random() - 0.5) * (2 * math.pi / amount) * 0.2

    local angle = baseAngle + jitter
    local x = radius * math.cos(angle)
    local y = radius * math.sin(angle)

    table.insert(levels, {x=x - levelSelectSize/2, y=y - levelSelectSize/2})
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

  {claim=function ()
    main.createRewardsEditPattern()
  end,
  description="Upgrade a pattern!"},

  {money = 15},
}

local function pickRandom(t)
  return t[love.math.random(1, #t)]
end

local function generateReward(index)
  local t
  if #levels == 2 then
    if index == 1 then
      t = pickRandom{rewardList[1], rewardList[2]}
    elseif index == 2 then
      t = pickRandom{rewardList[3], rewardList[5], rewardList[6], rewardList[7]}
    else
      t = rewardList[1]
    end
  elseif #levels == 3 then
    if index == 1 then
      t = rewardList[1]
    elseif index == 2 then
      t = rewardList[2]
    elseif index == 3 then
      t = pickRandom{rewardList[5], rewardList[6], rewardList[7]}
    else
      t = rewardList[1]
    end
  else
    t = rewardList[1]
  end
  t.difficulty = index
  return t
end

local firstName = {"XYZ", "Hyper", "Prime", "Quantum", "Zenith", "Clockwork", "Stasis", "Solar", "Lunar", "Elysian", "Aether", "Alpha"}
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


  -- if system.getStorage("main:currentScene") ~= "levelSelect" then
  --   return
  -- end
end)



--
-- side ui thingies
--




---
---save systems
---

-- store level, reward, objectives..?
system.register("levelSelect", 26, function ()
  local t = {
    uiInfos = {},
    usedEnemies=usedEnemies,
    cycleBossInfo=cycleBossInfo,
  }
  if system.getStorage("main:currentScene") ~= "levelSelect" then
    return false
  end

  for i, ui in ipairs(activeRouteUI) do
    t.uiInfos[i] = {}
    if ui.reward then
      local rewardIndex
      for e, reward in ipairs(rewardList) do
        if reward == ui.reward then
          rewardIndex = e
        end
      end
      if rewardIndex == nil then
        error("Reward failed to save")
      end
      t.uiInfos[i].rewardIndex = rewardIndex
    end
    if ui.name then
      t.uiInfos[i].name = ui.name
    end
    if ui.enemy then
      t.uiInfos[i].enemy = {}
      for e, enemy in ipairs(ui.enemy) do
        table.insert(t.uiInfos[i].enemy, enemy.id)
      end
    end
  end
  
  return t
end, function (t)
  if t == false then
    return
  end

  savedRouteUI = t
end)


--
-- scene definition
--
main.defineScene("levelSelect", function ()
  local currentTrack = route[currentCycle][currentRoute]

  table.insert(existingUI, main.ui.spawnUI("cover", {x=leftCoverX, y=-20, width=330, height=320,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.5, 0.5, 0.5}, outline=10}))

  currentNodeHovered = currentTrack.id
  local gap = 32
  local totalWidth = 32 + #route[currentCycle] * (gap+32)
  for i, track in ipairs(route[currentCycle]) do
    local x = leftCoverX+coverWidth/2-totalWidth/2+(gap+32)*(i-0.5)+16
    if track.id == "PLAY" then
      if i ~= #route[currentCycle] then
        local ui = main.ui.spawnUI("levelTrackIndicator", {
          x=x,
          y=250,
          image = "fightNode",
          node = "PLAY"
        })
        table.insert(listOfTrackIndicator, ui)
      else
        local ui = main.ui.spawnUI("levelTrackIndicator", {
          x=x,
          y=250,
          image = "bossNode",
          node = "PLAY"
        })
        table.insert(listOfTrackIndicator, ui)
      end

    elseif track.id == "SHOP" then
      local ui = main.ui.spawnUI("levelTrackIndicator", {
        x=x,
        y=250,
        image = "restNode",
        node = "SHOP"
      })
      table.insert(listOfTrackIndicator, ui)
    end
  end

  local amountOfNode

  if type(currentTrack.node) == "table" then
    amountOfNode = currentTrack.node[love.math.random(1, #currentTrack.node)]
  else
    amountOfNode = currentTrack.node
  end
  if savedRouteUI then
    amountOfNode = #savedRouteUI.uiInfos
  end

  generateLevelMap(amountOfNode)
  if system.getStorage("main:isDoingTutorial") and currentRoute == 1 and currentCycle == 1 then
    levels[1].x = 150
    levels[1].y = -100
  end

  for i, level in ipairs(levels) do
    local x = level.x
    local y = level.y
    local ui = main.ui.spawnUI("levelSelect", {x=x, y=y})
    ui.levelIndex = i
    if currentTrack.id == "PLAY" then
      local difficulty = i
      activeRouteUI[i] = ui
      if currentTrack.reward and currentTrack.reward[i] then
        ui.reward=rewardList[currentTrack.reward[i]]
        ui.reward.difficulty=i
      else
        ui.reward = generateReward(difficulty)
      end
      ui.name = generateNodeName()
      ui.scoreRequirement = getscoreRequirement(system.getStorage("main:currentDay"), difficulty)
      ui.moneyReward = ui.reward.money or 3
      ui.description = "Score Required: {priceColor}" .. ui.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. ui.moneyReward
      if ui.reward.description then ui.description = ui.description .. "\nRewards: " .. ui.reward.description end

      -- ui.enemy = {main.enemies.getRandomEnemy({enemyType="elite"}), main.enemies.getRandomEnemy({enemyType="boss"})}
      -- ui.enemy = {main.enemies.getEnemy("flow")}
      if currentTrack.enemy and currentTrack.enemy ~= "boss" then
        ui.enemy = {main.enemies.getRandomEnemy({enemyType=currentTrack.enemy, usedEnt=usedEnemies})}
        for _, enemy in ipairs(ui.enemy) do
          table.insert(usedEnemies, enemy.id)
        end
      elseif currentTrack.enemy == "boss" then
        ui.enemy = {main.enemies.getEnemy(cycleBossInfo[currentCycle])}
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

  
  -- save system
  if savedRouteUI then
    if savedRouteUI.usedEnemies then
      usedEnemies = savedRouteUI.usedEnemies
      cycleBossInfo = savedRouteUI.cycleBossInfo
    end
    for i, ui in ipairs(savedRouteUI.uiInfos) do
      local currentUI = activeRouteUI[i]
      if ui.rewardIndex then
        currentUI.reward = rewardList[ui.rewardIndex]
      end
      if ui.name then
        currentUI.name = ui.name
      end
      if ui.enemy then
        local t = {}
        for e, enemy in ipairs(ui.enemy) do
          table.insert(t, main.enemies.getEnemy(enemy))
        end
        currentUI.enemy = t
      end

      currentUI.description = "Score Required: {priceColor}" .. currentUI.scoreRequirement .. "{/priceColor}\nGives {moneyColor}$" .. currentUI.moneyReward
      if currentUI.reward.description then currentUI.description = currentUI.description .. "\nRewards: " .. currentUI.reward.description end
    end

    savedRouteUI = nil
  end

  if system.getStorage("main:isDoingTutorial") then
    if currentRoute == 1 and currentCycle == 1 then
      --todo fix this
      main.addEntityToTutorial(activeRouteUI[1], "Click here to begin\nyour encounter!")
    end
  end

  --objectives
  if currentTrack.id == "PLAY" then
    if #main.objectives.active == 0 then
      for i=1, 2 do
        main.objectives.createRandomObjective()
      end
    end

    objectiveCover = main.ui.spawnUI("cover", {x=0, y=80, width=1, height=1,
      color = {0.1, 0.1, 0.1, 0.4},
      outlineColor = {0.9, 0.9, 0.9}, outline=10, rx=20, ry=20})
    
    objectiveText = main.objectives.createObjectiveRichtext({x=1280,y=170,font=system.getFont("defaultFont30"), centerX=true})
    local maxwidth = 0
    for i, text in ipairs(objectiveText) do
      maxwidth = math.max(maxwidth, text.richText:getWidth())
    end
    for i, text in ipairs(objectiveText) do
      text.x = text.x - maxwidth/2 - 60
    end

    local header = main.newRichText({
      format = "OBJECTIVES",
      x = 1280,
      y = 100,
      renderLayer=100,
      outline = true,
      outlineColor={0,0,0}
    })
    table.insert(existingUI, header)
    header.x = header.x - header.richText:getWidth()/2
    header.x = header.x - maxwidth/2 - 60

    local highY, lowY = 80, objectiveText[#objectiveText].y + objectiveText[#objectiveText].richText:getHeight()
    objectiveCover.x = 1280-maxwidth-90
    objectiveCover.height = lowY-highY+30
    objectiveCover.width = maxwidth + 30 * 2
  end


  --enemy
  table.insert(existingUI, main.ui.spawnUI("cover", {x=leftCoverX, y=270, width=330, height=90+30,
    rx=20, ry=20,
    renderLayer=90,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.5, 0.5, 0.5}, outline=10}))

  local formatForText = {"Cycle " .. currentCycle .. "'s", "Boss"}
  for i=1, 2 do
    local t = main.newRichText({
      format = formatForText[i],
      x = leftCoverX+20,
      y = 300+45,
      renderLayer=100,
      font = system.getFont("defaultFont35"),
    })
    t.y = t.y - t.richText:getHeight()/2
    t.y = t.y + (i-1.5)*45/2
    table.insert(existingUI, t)
  end

  if cycleBossInfo[currentCycle] == nil then
    cycleBossInfo[currentCycle] = main.enemies.getRandomEnemy({enemyType="boss", usedEnt=cycleBossInfo}).id
  end

  enemyText = main.newRichText({
      format = "ENEMY",
      x = leftCoverX+330/2,
      y = 770,
      renderLayer=100,
    })
  enemyText.x = enemyText.x - enemyText.richText:getWidth()/2

  enemyCover = main.ui.spawnUI("cover", {x=leftCoverX, y=740, width=330, height=360,
    rx=20, ry=20,
    renderLayer=93,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.4, 0.4, 0.4}, outline=10})

  for k, ui in ipairs(activeRouteUI) do
    enemyNews[k] = {}
    if ui.enemy then
      local spacing = utils.createEvenlySpacedPosition(#ui.enemy)
      for i, enemy in ipairs(ui.enemy) do
        local id = enemy.id
        local n = main.spawnEntity(id, {x=0, y=800})
        n.ui.renderLayer = 102
        n.ui.sx = 2
        n.ui.sy = 2
        n.ui.ox = n.ui.width/2
        n.ui.oy = n.ui.height/2
        n.ui.screenSpace = true
        n.screenSpace = true
        table.insert(enemyNews[k], n)
      end
    end
  end


  if #enemyNews[1] > 0 then
    main.tweenCamera(0.2, {x=-180, y=-120, zoom=1})
  else
    main.tweenCamera(0.2, {x=0, y=-120, zoom=1})
  end

  main.hideCharts()


  main.wait(0.1, function ()
    system.saveGame()
  end)

  main.showTopTab()
end, function ()
  main.hideTopTab()
  
  lastLevelHovered = nil
  main.wait(1, function ()
    lastLevelHovered = nil
  end)
  if system.getStorage("main:isDoingTutorial") then
    main.clearTutorial()
  end

  deleteAll(existingUI)
  existingUI = {}
  deleteAll(listOfTrackIndicator)
  listOfTrackIndicator = {}
  deleteAll(activeRouteUI)
  activeRouteUI = {}
  if objectiveText then
    deleteAll(objectiveText)
  end

  for k, t in pairs(enemyNews) do
    for i, item in pairs(t) do
      item.ui:delete()
      item:delete()
    end
  end
  enemyNews={}

  deleteAll({objectiveCover, enemyCover, enemyText})

  levels = {}
end)

--juice
local juiceInfo={s=1, r=0}

system.answer("ui:getUIY", function (ent)
  if ent.id == "levelTrackIndicator" then
    return math.sin((ent.x*10+juiceInfo.r*10)/10)*5
  end
  return 0
end)

local function scaleChange()
  flux.to(juiceInfo, 5, {s=1.1}):ease("linear")
  main.wait(5, function ()
    flux.to(juiceInfo, 5, {s=0.9}):ease("linear")
    main.wait(5, function ()
      scaleChange()
    end)
  end)
end

scaleChange()

local function sortEnemiesIntoATable(level)
  local enemies = {}

  for _, enemy in ipairs(enemyNews[level.levelIndex]) do
    local tier = enemyTiers[enemy.enemyType]
    enemies[tier] = enemies[tier] or {}
    table.insert(enemies[tier], enemy)
  end

  local usedTiers = {}
  for tier, e in pairs(enemies) do
    table.insert(usedTiers, tier)
  end
  table.sort(usedTiers)

  local returnTable = {}
  for i, tier in ipairs(usedTiers) do
    returnTable[i] = {}
    for _, enemy in ipairs(enemies[tier]) do
      table.insert(returnTable[i], enemy)
    end
  end

  return returnTable
end

system.on("@draw", function ()
  if system.getStorage("main:currentScene") ~= "levelSelect" then
    return
  end

  juiceInfo.r = juiceInfo.r + system.getStorage("dt")
  if juiceInfo.r > math.pi*2 then
    juiceInfo.r = 0
  end

  system.render(3, function ()
    
    for i, ui in ipairs(activeRouteUI) do
      love.graphics.setColor(1, 1, 1, 0.2)
      love.graphics.setLineWidth(4)
      love.graphics.line(ui:getX()+ui:getWidth()/2, ui:getY()+ui:getHeight()/2, 0, 0)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(system.getImage("baseNetwork"), 0, 0, 0, juiceInfo.s, juiceInfo.s, 48, 48)
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

  local x = rightCoverx+coverWidth/2
  local y = 200


  system.render(98, function ()
    love.graphics.setLineWidth(5)
    love.graphics.setColor(0.9, 0.9, 0.9, 0.6)
    for i=1, #listOfTrackIndicator-1 do
      local node = listOfTrackIndicator[i]
      local secondNode = listOfTrackIndicator[i+1]
      local y1 = system.ask("ui:getUIY", combiner.ADD, node)
      local y2 = system.ask("ui:getUIY", combiner.ADD, secondNode)
      local y = (y1+y2)/2
      love.graphics.line(node.x+24, y, secondNode.x-24, y)
    end
  end, true)

  local currentNode = listOfTrackIndicator[currentRoute]
  if currentNode then
    local y = system.ask("ui:getUIY", combiner.ADD, currentNode)
    system.render(102, function ()
      love.graphics.draw(system.getImage("currentNode"), currentNode.x, y, juiceInfo.r, 1.4, 1.4, 24, 24)
    end, true)
  end

  local currentTrack = route[currentCycle][currentRoute]
  if currentTrack and enemyCover then
    local tierGap = 80
    for i, ui in ipairs(activeRouteUI) do
      if ui.enemy and #ui.enemy > 0 then
        if lastLevelHovered ~= ui then
          for e, tier in ipairs(sortEnemiesIntoATable(ui)) do
            local xGap = utils.createEvenlySpacedPosition(#tier)
            for k, enemy in ipairs(tier) do
              flux.to(enemy.ui, 0.3, {y=800+tierGap*(e-1), x=leftCoverX+330/2 + 90*xGap[k]})
            end
          end
        else
          for e, tier in ipairs(sortEnemiesIntoATable(ui)) do
            local xGap = utils.createEvenlySpacedPosition(#tier)
            for k, enemy in ipairs(tier) do
              flux.to(enemy.ui, 0.3, {y=720-340/2+tierGap*(e-1), x=leftCoverX+330/2 + 90*xGap[k]})
            end
          end
        end
      end
    end

    system.render(100, function ()
      love.graphics.setLineWidth(5)
      local y = enemyText.y + enemyText.richText:getHeight() + 15
      love.graphics.line(enemyCover.x+40, y, enemyCover.x+330-40, y)
    end, true)

    if lastLevelHovered and lastLevelHovered.enemy and #lastLevelHovered.enemy > 0 then
      flux.to(enemyCover, 0.3, {y=720-340})
      flux.to(enemyText, 0.3, {y=720-340+30})
    else
      flux.to(enemyCover, 0.3, {y=740})
      flux.to(enemyText, 0.3, {y=720+30})
    end
  end
end)

main.ui.defineUI("levelSelect", {
  -- change these when spawned
  name = "Level",
  description = "nothing much here",
  image = "levelSelect",
  text = "1",
  renderLayer = 4,
  moneyReward = 0,
  reward = nil,
  showDescription = true,
  width = 64,
  height= 64,
  ox=32,
  oy=32,
  screenSpace = false,
  scoreRequirement = 0,
  targetScene = "play",
  isTweening=false,
  onHover = function (ent)
    if ent.isTweening == false then
      ent.tween = flux.to(ent, 0.3, {sx=2, sy=2}):ease("backinout")
      ent.isTweening=true
    end
    lastLevelHovered = ent
  end,
  notHovered = function (ent)
    if ent.isTweening == true then
      ent.tween = flux.to(ent, 0.3, {sx=1, sy=1}):ease("backinout")
      ent.isTweening=false
    end
  end,
  onMouseReleased = function (ent, button)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      system.updateStorage("main:moneyReward", ent.moneyReward)
      system.updateStorage("main:scoreRequirement", ent.scoreRequirement)
      -- system.updateStorage("main:scoreRequirement", 1)
      main.playScene(ent.targetScene)
      if ent.reward and ent.reward.claim then
        local reward = system.getStorage("main:endLevelReward")
        table.insert(reward, ent.reward)
      end

      if ent.enemy then
        for i, enemy in ipairs(ent.enemy) do
          local e = main.spawnNews(enemy.id, {x=0,y=0})
          e.ui.isVisible = false
        end
      end

      local currentRoute = system.getStorage("main:currentRoute")
      local cycle = system.getStorage("main:currentCycle")
      system.updateStorage("main:currentRoute", currentRoute + 1)
      if currentRoute == #system.getStorage("main:route")[cycle] then
        system.updateStorage("main:currentRoute", 1)
        system.updateStorage("main:currentCycle", cycle + 1)
        system.updateStorage("main:currentDay", 0)
      end
    end
  end,
})

main.ui.defineUI("levelTrackIndicator", {
  image = "fightNode",
  renderLayer = 100,
  width = 32,
  height= 32,
  ox=16,
  oy=16,
  sx=1.4,
  sy=1.4,
  screenSpace = true,
  isTweening=false,
  onHover = function (ent)
    if ent.isTweening == false then
      ent.tween = flux.to(ent, 0.3, {sx=2.2, sy=2.2}):ease("backout")
      ent.isTweening=true
    end
    currentNodeHovered = ent.node
  end,
  notHovered = function (ent)
    if ent.isTweening == true then
      ent.tween = flux.to(ent, 0.3, {sx=1.4, sy=1.4}):ease("backout")
      ent.isTweening=false
    end
  end,
  onMouseReleased = function (ent, button)

  end,
})