local biggerFont = system.getFont("defaultFont100")
local flux = system.getStorage("flux")
local score = system.getStorage("main:score")
local scoreText = main.newRichText({format="Score: " ..  math.floor(score+0.5) .. "",
  y=80,
  x=70,
  renderLayer = 200,})

local money = main.getMoney()

-- local energyText = main.newRichText({format="0",
--   y=130,
--   x=70,
--   renderLayer = 200,})

local roundsRemainingText = main.newRichText({format="Turn left: 0",
  y=130,
  x=70,
  renderLayer = 200,})

local moneyText = main.newRichText({format="{moneyColor}$" .. money .. "{/moneyColor}",
  y=180,
  x=70,
  renderLayer = 200,})

local priceText = main.newRichText({format="{priceColor}" ..  math.floor(0+0.5) .. "{/priceColor}",
  y=300,
  x=0,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  renderLayer = 200,
  font = biggerFont})

local multText = main.newRichText({format="{multColor}X" ..  math.floor(0+0.5) .. "{/multColor}",
  y=300,
  x=0,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  renderLayer = 200,
  font = biggerFont,
  })

local cardHeldText = main.newRichText({format=0 .. "/" .. system.getStorage("main:maxCardAmount"),
  y=525,
  x=0,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  renderLayer = 200,})

--score text
local scoreInfos = {currentScore=0, score=0, scoreToClaim=0}
system.on("main:scoreChanged", function (change)
  local score = system.getStorage("main:score")
  scoreInfos.currentScore = score
  scoreInfos.scoreToClaim = change
  main.wait(1, function ()
    flux.to(scoreInfos, 0.7, {score=scoreInfos.currentScore, scoreToClaim=0})
  end)

  priceText.isVisible = false
  multText.isVisible = false
  main.wait(2.2, function ()
    priceText.isVisible = true
    multText.isVisible = true
  end)
end)

system.on("@update", function ()
  local score = system.getStorage("main:score")
  local scoreRequired = system.getStorage("main:scoreRequirement")
  main.updateRichTextText(scoreText, "Score: " .. math.floor(scoreInfos.score+0.5) .. "/" .. scoreRequired)
  if scoreInfos.scoreToClaim > 0 then
    local t = main.printRichText({
      format=math.floor(scoreInfos.scoreToClaim+0.5),
      y=300,
      x=50+350*2/4,
      sx=1,
      sy=1,
      ox=1,
      oy=1,
      r=0,
      renderLayer = 200,
      font = biggerFont})
    t.x, t.y = t.x - t.richText:getWidth()/2, t.y - t.richText:getHeight()/2
  end
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    scoreText.x = -2000
  end
  if scene == "play" then
    local scoreRequired = system.getStorage("main:scoreRequirement")
    main.updateRichTextText(scoreText, "Score: " .. math.floor(score+0.5) .. "/" .. scoreRequired)
    scoreText.x = 70
  end
end)

--money text
system.on("main:moneyChanged", function ()
  local money = main.getMoney()
  main.updateRichTextText(moneyText, "{moneyColor}$" .. math.floor(money) .. "{/moneyColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if utils.isEInTable(scene, {"play", "shop"}) then
    moneyText.x = 70
  else
    moneyText.x = -2000
  end

  if scene == "play" then
    moneyText.y = 180
    moneyText.sx = 1
    moneyText.sy = 1
  elseif scene == "shop" then
    moneyText.y = 160
  end
end)

--energy
local energyInfos = {w=0}
system.on("@update", function ()
  local energy = system.getStorage("main:energy")
  local energyPerTurn = system.getStorage("main:energyPerTurn")
  local widthPerBar = 330/energyPerTurn
  flux.to(energyInfos, 0.2, {w=math.max(0, widthPerBar*math.min(energyPerTurn, energy)-20)})
end)

system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

  local energy = system.getStorage("main:energy")
  local energyPerTurn = system.getStorage("main:energyPerTurn")
  system.render(200, function ()
    local widthPerBar = 330/energyPerTurn

    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.rectangle("fill", 60, 370, 330, 100, 20, 20)

    local r = math.min(20, math.max(0, energyInfos.w))
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", 70, 380, 310, 80, 20, 20)
    
    love.graphics.setColor(1, 0.7, 0.3, 1)
    love.graphics.rectangle("fill", 70, 380, energyInfos.w, 80, r, r)

    love.graphics.setColor(0.3, 0.3, 0.3, 1)
    love.graphics.setLineWidth(10)
    for i=1, (energyPerTurn-1) do
      local x = 60+i*widthPerBar
      love.graphics.line(x, 372, x, 468)
    end
  end, true)

  if energy > energyPerTurn then
    local t=main.printRichText({
      x=330,
      y=420,
      format="{energyColor g=0.9 b=0.5}+" .. energy-energyPerTurn,
      renderLayer=201,
      font=biggerFont,
      screenSpace = true
    })
    t.x = t.x - t.richText:getWidth()/2
    t.y = t.y - t.richText:getHeight()/2
  end
end)

-- roundsRemainingText
system.on("@update", function ()
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  if roundsRemaining then
    main.updateRichTextText(roundsRemainingText, "Turn left: " .. roundsRemaining)
  end
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if utils.isEInTable(scene, {"play"}) then
    roundsRemainingText.x = 70
  else
    roundsRemainingText.x = -2000
  end
end)

-- pricetext
system.on("@update", function ()
  local bar = system.getStorage("main:currentBar")
  if bar then
    local currentPrice = bar.endPrice - bar.startPrice
    main.updateRichTextText(priceText, "{priceColor}" ..  math.floor(currentPrice+0.5) .. "{/priceColor}")
  end
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    priceText.x = -2000
  end
  if scene == "play" then
    priceText.x = 50+350/4
  end
end)

-- mult text
system.on("@update", function ()
  local mult = system.getStorage("main:mult")
  main.updateRichTextText(multText, "{multColor}" ..  math.floor(mult+0.5) .. "{/multColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    multText.x = -2000
  end
  if scene == "play" then
    multText.x = 50+350*3/4
  end
end)

system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

  system.render(199, function ()
    love.graphics.setColor(0.4, 0.4, 0.4, 1)
    love.graphics.rectangle("fill", 55, 250, 340, 90)
    -- love.graphics.setColor(0.45, 0.45, 0.45, 1)
    -- love.graphics.rectangle("fill", 60, 350, 330/2-10, 100)
    -- love.graphics.setColor(0.45, 0.45, 0.45, 1)
    -- love.graphics.rectangle("fill", 60+330/2+10, 350, 330/2-10, 100)
  end, true)
end)

-- hold%
-- system.on("@draw", function ()
--   local scene = system.getStorage("main:currentScene")
--   if scene ~= "play" then
--     return
--   end

--   if system.getStorage("main:isOnTurn") ~= true then
--     return
--   end

--   local owned = system.getStorage("main:ownedPercentage")

--   local t = main.printRichText({
--     format=owned/100 .. "X",
--     x=640,
--     y=150,
--     renderLayer=200,
--     font = biggerFont
--   })
--   t.x = t.x - t.richText:getWidth()/2
-- end)

-- cardHeldText

system.on("@update", function ()
  local format = #main.card.hand .. "/" .. system.getStorage("main:maxCardAmount")
  main.updateRichTextText(cardHeldText, format)

  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    cardHeldText.x = -2000
  end
  if scene == "play" then
    cardHeldText.x = 640-cardHeldText.richText:getWidth()/2
  end
end)

-- juice
local function makeJuice(text, event)
  system.on(event, function ()
    local originalRotation = 0
    local rotation = text.r + (love.math.random()-0.5)*3
    local scaleFactor = 1.5
    local sx = text.sx * scaleFactor
    local sy = text.sy * scaleFactor
    flux.to(text, 0.1, {sx = sx, sy=sy, r=rotation})
    main.wait(0.1, function ()
      flux.to(text, 0.1, {sx = 1, sy=1,r=originalRotation})
    end)
  end)

  system.on("@update", function ()
    local richText = text.richText
    local ox = richText:getWidth()/2
    local oy = richText:getHeight()/2
    text.ox = ox
    text.oy = oy
  end)
end

makeJuice(priceText, "main:currentPriceChanged")
makeJuice(multText, "main:multChanged")