local pipeline = main.getPipeline("main")
local cover
local objectiveCover
local objectiveText
-- local ownSlider
local scaleYSlider
local startTurn
local settings
local setting
local drawPile, discardPile

--tutorial, stage kinda like a rocketship :)
local tutorialInfos = system.getStorage("main:tutorialInfos")

local function deleteAll(args)
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

system.on("@update", function ()
  tutorialInfos = system.getStorage("main:tutorialInfos")

  if objectiveText then
    main.objectives.updateObjectiveRichtext(objectiveText)
  end
end)

main.defineScene("play", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=360,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=10, rx=20, ry=20})
  objectiveCover = main.ui.spawnUI("cover", {x=1280-350, y=100, width=370, height=240,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=10, rx=20, ry=20})
  
  startTurn = main.ui.spawnUI("startTurn", {x=640-100, y=30})
  drawPile = main.ui.spawnUI("drawPile", {x=1280-60, y=720-60})
  discardPile = main.ui.spawnUI("discardPile", {x=60, y=720-60})
  settings = main.ui.spawnUI("openSetting", {x=1280-30-60, y=30, width=60, height=60, color={0.8, 0.8, 0.8}})
  main.updateRichTextText(settings.richtext, "=")

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

  objectiveText = main.objectives.createObjectiveRichtext({x=1280-320,y=130,font=system.getFont("defaultFont30"), showProgress=true})

  main.showCharts()
end, function ()
  local chart = system.getStorage("main:chart")
  system.updateStorage("main:currentDay", system.getStorage("main:currentDay")+1)
  local endStats = {
    finalScore = system.getStorage("main:score"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, scaleYSlider, startTurn, setting, drawPile, discardPile, settings, objectiveCover})
  deleteAll(objectiveText)
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
    if c == nil then
      return
    end
    tutorialInfos.stage = 5
    main.addEntityToTutorial(c, "Remember that {redColor}negative{/redColor} {priceColor}{priceIcon}PRICE{/priceColor}\nis just another way to win!")
  elseif tutorialInfos.stage == 5 then
    main.clearTutorial()
    main.spawnNews("tips", {x=0, y=0})
    system.updateStorage("main:isDoingTutorial", false)
    tutorialInfos.stage = 6
  end
end)