local pipeline = main.getPipeline("main")
local cover
-- local ownSlider
local scaleYSlider
local sell
local buy

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

  local dimension = system.getStorage("screenDimension")
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=360,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=10, rx=20, ry=20})
  
  sell = main.ui.spawnUI("startTurn", {x=640-85-75, y=50, mult=-1, color={0.7, 0.4, 0.4}})
  main.updateRichTextText(sell.richtext, "DOWN")
  buy = main.ui.spawnUI("startTurn", {x=640+85-75, y=50, color={0.4, 0.7, 0.4}})
  main.updateRichTextText(buy.richtext, "UP")


  if system.getStorage("main:isDoingTutorial") then
    main.drawCard()
    main.addEntityToTutorial(main.card.hand[1], "Play a card\nfrom your hand")
    tutorialInfos.cardChoice = main.card.hand[1]
    sell.isVisible = false
    buy.isVisible = false
  else
    main.drawCardTillMaxCapacity()
    main.spawnBarChangeNews()

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

  for i, card in ipairs(main.card.hand) do
    card.isLocked = false
  end
  for i, card in ipairs(main.card.draw) do
    card.isLocked = false
  end
  for i, card in ipairs(main.card.discard) do
    card.isLocked = false
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
  deleteAll({cover, scaleYSlider, sell, buy})
  chart:clear()

  local bar = main.spawnBar()
  system.updateStorage("main:ownedPercentage", 0)

  for i, card in ipairs(main.card.hand) do
    card.isLocked = true
  end
  for i, card in ipairs(main.card.draw) do
    card.isLocked = true
  end
  for i, card in ipairs(main.card.discard) do
    card.isLocked = true
  end
end)

--tutorial
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
    print(buy.renderLayer)
  end
end)

system.on("main:endTurn", function ()
  if tutorialInfos.stage == 3 then
    main.wait(2, function ()
      local chart = system.getStorage("main:chart")
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