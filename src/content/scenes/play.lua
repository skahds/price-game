local flux = system.getStorage("flux")
local pipeline = main.getPipeline("main")
local cover
local objectiveCover, objectiveArrow
local objectiveText
-- local ownSlider
local scaleYSlider
local startTurn
local drawPile, discardPile

--tutorial, stage kinda like a rocketship :)
local tutorialInfos = system.getStorage("main:tutorialInfos")

local isObjectiveClosed = false

local function deleteAll(args)
  if args == nil then return end
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

local gap = 30
system.on("@update", function ()
  tutorialInfos = system.getStorage("main:tutorialInfos")

  if objectiveText then
    main.objectives.updateObjectiveRichtext(objectiveText)
    local maxWidth = 0
    for i, text in ipairs(objectiveText) do
      maxWidth = math.max(maxWidth, text.richText:getWidth())
      text.x = objectiveCover.x + gap
    end
    local highY, lowY = objectiveText[1].y, objectiveText[#objectiveText].y+objectiveText[#objectiveText].richText:getHeight()
    local height = lowY-highY
    objectiveCover.width = maxWidth+gap*2
    objectiveCover.height = height+gap*2

    objectiveArrow.x = objectiveCover.x - 50
    objectiveArrow.y = objectiveCover.y + objectiveCover.height/2 - 32

    if isObjectiveClosed then
      flux.to(objectiveCover, 0.3, {x=1285})
      objectiveArrow.image = "objectivePanelArrowLeft"
    else
      flux.to(objectiveCover, 0.3, {x=1280-maxWidth-gap*2})
      objectiveArrow.image = "objectivePanelArrowRight"
    end
  end
end)

main.defineScene("play", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=360,
    color = {0.6, 0.6, 0.6},
    outlineColor = {0.5, 0.5, 0.5}, outline=10, rx=20, ry=20})
  
  startTurn = main.ui.spawnUI("startTurn", {x=640-100, y=90})
  drawPile = main.ui.spawnUI("drawPile", {x=1280-60, y=720-60})
  discardPile = main.ui.spawnUI("discardPile", {x=60, y=720-60})

  if system.getStorage("main:isDoingTutorial") and tutorialInfos.stage == 1 then
    main.drawCard()
    main.addEntityToTutorial(main.card.hand[1], "Click this card\nto select it")
    tutorialInfos.cardChoice = main.card.hand[1]
    startTurn.isVisible = false
  else
    main.shuffleDiscardToDraw()
    main.shuffleDraw()
    main.drawCardTillMaxCapacity()

    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()
    local exist = false
    chart:forAllNews(function (news)
      if news.id == "randomEvents" then
        exist = true
      end
    end)
    if exist == false then
      main.spawnNews("randomEvents", {x=pos.x-64, y=pos.y-32})
    end
  end

  if system.getStorage("main:chart") and system.getStorage("main:chart"):getBar(1) == nil then
    main.spawnBar()
  end

  system.updateStorage("main:roundsRemaining", system.getStorage("main:roundsPerDay"))

  local piles = {main.card.hand, main.card.draw, main.card.discard}
  for _, pile in ipairs(piles) do
    for i, card in ipairs(pile) do
      card.isLocked = false
    end
  end

  local currentRoute = system.getStorage("main:currentRoute") or 1
  local currentCycle = system.getStorage("main:currentCycle") or 1

  if system.getStorage("main:isDoingTutorial") and currentRoute==1 and currentCycle==1 then

  else
    objectiveCover = main.ui.spawnUI("cover", {x=1280-350, y=140, width=370, height=100,
      color = {0.1, 0.1, 0.1, 0.4},
      outlineColor = {0.9, 0.9, 0.9}, outline=10, rx=20, ry=20})
    objectiveArrow = main.ui.spawnUI("objectivePanelArrow", {x=1280-480, y=140+100/2-100/2})

    objectiveText = main.objectives.createObjectiveRichtext({x=1280-320,y=170,font=system.getFont ("defaultFont30"), showProgress=true})
  end

  main.showCharts()
  main.showTopTab()
end, function ()
  main.hideTopTab()
  
  local chart = system.getStorage("main:chart")
  local endStats = {
    finalScore = system.getStorage("main:score"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, scaleYSlider, startTurn, drawPile, discardPile, objectiveCover, objectiveArrow})
  if objectiveText then
    deleteAll(objectiveText)
  end
  objectiveText = nil
  chart:clear()

  local bar = main.spawnBar()
  system.updateStorage("main:ownedPercentage", 0)

  local piles = {main.card.hand, main.card.draw, main.card.discard}
  for _, pile in ipairs(piles) do
    for i, card in ipairs(pile) do
      card.isLocked = true
      card.overrideEnergy=card.energy
      card.repeatActivation=0
    end
  end
end)


-- objective uis
main.ui.defineUI("objectivePanelArrow", {
  defaultWidth = 50,
  defaultHeight = 100,
  image = "objectivePanelArrowRight",
  screenSpace = true,
  renderLayer = 50,
  onMouseReleased = function (ent, button)
    if isObjectiveClosed then
      isObjectiveClosed = false
    else
      isObjectiveClosed = true
    end
  end,
})



--tutorial
system.on("main:cardClicked", function (ent)
  if system.getStorage("main:isDoingTutorial") ~= true then
    return
  end

  if tutorialInfos.stage == 1 then
    main.clearTutorial()
    main.addEntityToTutorial(main.card.hand[1], "Move your mouse up\nand click to activate!\n(consumes {energyColor}{energyIcon}ENERGY{/energyColor})")
  end
end)

system.on("main:entityTriggered", function (ent)
  if system.getStorage("main:isDoingTutorial") ~= true then
    return
  end

  if tutorialInfos.stage == 1 then
    if tutorialInfos.cardChoice and tutorialInfos.cardChoice.index == ent.index then
      main.removeEntityFromTutorial(tutorialInfos.cardChoice)
      tutorialInfos.cardChoice = nil
      for i=1, 4 do
        pipeline:add(0.25, function ()
          main.drawCard()
        end)
      end
      tutorialInfos.stage = 2
    end
  elseif tutorialInfos.stage == 2 then
    if system.getStorage("main:energy") == 0 then
      startTurn.isVisible = true
      main.addEntityToTutorial(startTurn, "When you're done with your turn, press here!\nyou will gain the amount of score\nwhether {priceColor}{priceIcon}PRICE{/priceColor} is {greenColor}positive{/greenColor} or {redColor}negative{/redColor}!")
    end
  elseif tutorialInfos.stage == 7 then
    main.clearTutorial()
    main.spawnNews("tips", {x=0, y=0})
    system.updateStorage("main:isDoingTutorial", false)
  end
end)

system.on("main:startTurn", function ()
  if tutorialInfos.stage == 2 then
    main.clearTutorial()
    tutorialInfos.stage = 3
  end
end)

system.on("main:endTurn", function ()
  if tutorialInfos.stage == 3 then
    main.wait(2, function ()
      local chart = system.getStorage("main:chart")
      main.spawnNews("badNews", {x=0,y=0})
      local n = chart:getNews(1)
      if n then
        main.addEntityToTutorial(n, "This is a news, it activates\nwhen the turn starts.")
      end
      tutorialInfos.stage = 4
    end)
  end
end)

system.on("@mouse:released", function ()
  if tutorialInfos.stage == 4 then
    main.clearTutorial()
    local c = main.getCardInOrder(3)
    tutorialInfos.stage = 5
    if c == nil then
      return
    end
    main.addEntityToTutorial(c, "Remember that {redColor}negative{/redColor} {priceColor}{priceIcon}PRICE{/priceColor}\nis just another way to win!")
  elseif tutorialInfos.stage == 5 then
    main.clearTutorial()
    tutorialInfos.stage = 6
  end
end)

system.on("main:endTurn", function ()
  if tutorialInfos.stage == 6 then
    main.wait(2, function ()
      local c = main.getCardInOrder(3)
      print(c)
      if c == nil then
        return
      end
      main.addEntityToTutorial(c, "This is a placeable news, identified by the \"- News\"\nActivating it will place the news on your mouse's location")
      tutorialInfos.stage = 7
    end)
  end
end)