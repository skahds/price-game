local pipeline = main.getPipeline("main")
local cover
-- local ownSlider
local scaleYSlider
local sell
local buy
local setting
local drawPile, discardPile

--tutorial, stage kinda like a rocketship :)
local tutorialInfos = {stage=1}

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("play", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=360,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=10, rx=20, ry=20})
  
  sell = main.ui.spawnUI("startTurn", {x=640-85-75, y=50, mult=-1, color={0.7, 0.4, 0.4}})
  main.updateRichTextText(sell.richtext, "DOWN")
  buy = main.ui.spawnUI("startTurn", {x=640+85-75, y=50, color={0.4, 0.7, 0.4}})
  main.updateRichTextText(buy.richtext, "UP")
  drawPile = main.ui.spawnUI("drawPile", {x=1280-60, y=720-60})
  discardPile = main.ui.spawnUI("discardPile", {x=60, y=720-60})

  if system.getStorage("main:isDoingTutorial") and tutorialInfos.stage == 1 then
    main.drawCard()
    main.addEntityToTutorial(main.card.hand[1], "Click this card\nto select it")
    tutorialInfos.cardChoice = main.card.hand[1]
    sell.isVisible = false
    buy.isVisible = false
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

  system.updateStorage("main:roundsRemaining", system.getStorage("main:roundsPerDay"))

  local piles = {main.card.hand, main.card.draw, main.card.discard}
  for _, pile in ipairs(piles) do
    for i, card in ipairs(pile) do
      card.isLocked = false
    end
  end

  main.showCharts()
end, function ()
  local chart = system.getStorage("main:chart")
  system.updateStorage("main:currentDay", system.getStorage("main:currentDay")+1)
  local endStats = {
    finalScore = system.getStorage("main:score"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, scaleYSlider, sell, buy, setting, drawPile, discardPile})
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
    main.addEntityToTutorial(main.card.hand[1], "Move your mouse up\nand press to activate!\n(consumes energy)")
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
    if system.getStorage("main:energy") == 1 then
      buy.isVisible = true
      sell.isVisible = true
      main.addEntityToTutorial(buy, "When you think the price\nwill go up, click here!")
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
      main.addEntityToTutorial(n, "This is a news, it activates\nwhen the turn starts.")
      tutorialInfos.stage = 4
    end)
  end
end)

system.on("@mouse:released", function ()
  if tutorialInfos.stage == 4 then
    main.clearTutorial()
    tutorialInfos.stage = 5
  end
end)