local renderLayer = 30
local tutorialInfos = {}

local function format(n)
  if n >= 0 then
    return "+" .. n
  else
    return n
  end
end

system.on("@update", function ()
  tutorialInfos = system.getStorage("main:tutorialInfos")
end)

system.on("@draw", function ()
  local pattern = main.getCurrentPattern()
  if pattern == nil then
    return
  end

  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end

  if system.getStorage("main:isOnTurn") == true then
    return
  end

  local amountOfBar = #pattern.sequence
  local x = chart:getBar(-amountOfBar).x
  local width = chart:getBar(-1).x+chart:getBar(-1).width-chart:getBar(-amountOfBar).x
  local y = math.huge
  local lowestY = -math.huge
  local height = 0
  for i=#chart.bars, #chart.bars-amountOfBar+1, -1 do
    y = math.min(y, math.min(chart.bars[i].y, chart.bars[i].y+chart.bars[i].height))
    lowestY = math.max(lowestY, math.max(chart.bars[i].y, chart.bars[i].y+chart.bars[i].height))
  end
  height = lowestY - y

  local t = main.printRichText({
    format = pattern.name,
    renderLayer = renderLayer,
    x=x+width/2,
    y=y-5,
    screenSpace = false,
    font = system.getFont("defaultFont20"),
    outline=true,
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y - t.richText:getHeight()

  local t = main.printRichText({
    format = "{multColor}" ..format(pattern.mult) .. " {multIcon}MULT",
    renderLayer = renderLayer,
    x=x+width/2,
    y=y+height+5,
    screenSpace = false,
    font = system.getFont("defaultFont20"),
    outline=true,
  })
  t.x = t.x - t.richText:getWidth()/2

  local t = main.printRichText({
    format = "{priceColor}" ..format(pattern.price) .. " {priceIcon}PRICE",
    renderLayer = renderLayer,
    x=x+width/2,
    y=y+height+5,
    screenSpace = false,
    font = system.getFont("defaultFont20"),
    outline=true,
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y + t.richText:getHeight()

  system.render(renderLayer, function ()
    love.graphics.setColor(1, 1, 1, 0.75)
    love.graphics.setLineWidth(3)
    love.graphics.rectangle("line", x, y, width, height)
  end)
end)

system.on("main:entityTriggered", function (ent)
  if system.getStorage("main:isDoingTutorial") ~= true then
    return
  end

  local chart = system.getStorage("main:chart")
  if tutorialInfos.stage == 2 and tutorialInfos.patternsStage == nil then
    main.addEntityToTutorial(chart:getBar(-1), "Based on the direction\nof the bar, you will\nfind and create patterns")
    renderLayer = 310
    tutorialInfos.patternsStage = 1
  end
end)

system.on("@mouse:released", function ()
  if tutorialInfos.patternsStage == nil then
    return
  end

  if tutorialInfos.patternsStage == 1 then
    tutorialInfos.patternsStage = 2
  elseif tutorialInfos.patternsStage == 2 then
    local chart = system.getStorage("main:chart")
    main.clearTutorial()
    main.addEntityToTutorial(chart:getBar(-1), "These patterns gives\n{priceIcon}{priceColor}PRICE{/priceColor} and {multIcon}{multColor}MULT{/multColor}\nwhen the round starts")
    tutorialInfos.patternsStage = 3
  elseif tutorialInfos.patternsStage == 3 then
    renderLayer = 30
    main.clearTutorial()
    tutorialInfos.patternsStage = 4
  elseif tutorialInfos.patternsStage == 5 then
    tutorialInfos.patternsStage = 6
  elseif tutorialInfos.patternsStage == 6 then
    local chart = system.getStorage("main:chart")
    tutorialInfos.patternsStage = 7
    main.clearTutorial()
    main.addEntityToTutorial(chart:getBar(-1), "You can find out more patterns\nthrough the menu (top right)!")
  elseif tutorialInfos.patternsStage == 7 then
    main.clearTutorial()
    tutorialInfos.patternsStage = 8
    renderLayer = 30
  end
end)

system.on("main:currentPriceChanged", function ()
  if tutorialInfos.patternsStage == 4 and tutorialInfos.stage > 5 then
    tutorialInfos.patternsStage = 5
    local chart = system.getStorage("main:chart")
    main.addEntityToTutorial(chart:getBar(-1), "You have created a new pattern!")
    renderLayer = 310
  end
end)