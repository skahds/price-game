local biggerFont = system.getFont("defaultFont100")
local score = system.getStorage("main:score")
local scoreText = main.newRichText({format="Score: " ..  math.floor(score+0.5) .. "",
  y=80,
  x=70,
  renderLayer = 200,})

local money = main.getMoney()
local moneyText = main.newRichText({format="{moneyColor}$" .. money .. "{/moneyColor}",
  y=130,
  x=70,
  renderLayer = 200,})

local energyText = main.newRichText({format="0",
  y=180,
  x=70,
  renderLayer = 200,})

local roundsRemainingText = main.newRichText({format="Bars: 0",
  y=230,
  x=70,
  renderLayer = 200,})

local multText = main.newRichText({format="{multColor}X" ..  math.floor(0+0.5) .. "{/multColor}",
  y=160,
  x=0,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  renderLayer = 200,
  font = biggerFont,
  })

local pointText = main.newRichText({format="{pointColor}" ..  math.floor(0+0.5) .. "{/pointColor}",
  y=80,
  x=0,
  sx=1,
  sy=1,
  ox=1,
  oy=1,
  r=0,
  renderLayer = 200,
  font = biggerFont})

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
system.on("main:scoreChanged", function ()
  local score = system.getStorage("main:score")
  local scoreRequired = system.getStorage("main:scoreRequirement")
  main.updateRichTextText(scoreText, "Score: " .. math.floor(score+0.5) .. "/" .. scoreRequired)
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
end)

--energy text
system.on("@update", function ()
  local energy = system.getStorage("main:energy")
  local energyPerTurn = system.getStorage("main:energyPerTurn")
  main.updateRichTextText(energyText, "Energy: {energyColor}"..energy.."/"..energyPerTurn)
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if utils.isEInTable(scene, {"play", "shop"}) then
    energyText.x = 70
  else
    energyText.x = -2000
  end
end)

-- roundsRemainingText
system.on("@update", function ()
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  if roundsRemaining then
    main.updateRichTextText(roundsRemainingText, "Bars: " .. roundsRemaining)
  end
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if utils.isEInTable(scene, {"play", "shop"}) then
    roundsRemainingText.x = 70
  else
    roundsRemainingText.x = -2000
  end
end)

-- mult text
system.on("@update", function ()
  local mult = system.getStorage("main:mult")
  main.updateRichTextText(multText, "{multColor}X" ..  math.floor(mult+0.5) .. "{/multColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    multText.x = -2000
  end
  if scene == "play" then
    multText.x = 1100
  end
end)

-- pointtext
-- local currentPoint = 0
system.on("@update", function ()
  local bar = system.getStorage("main:currentBar")
  if bar then
    local currentPoint = bar.endPrice - bar.startPrice
    main.updateRichTextText(pointText, "{pointColor}" ..  math.floor(currentPoint+0.5) .. "{/pointColor}")
  end
end)

-- system.on("main:endTurn", function ()
--   pointText = 0
--   main.updateRichTextText(currentscoreText, "{pointColor}0{/pointColor}")
-- end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    pointText.x = -2000
  end
  if scene == "play" then
    pointText.x = 1100
  end
end)

-- hold%
system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

  if system.getStorage("main:isOnTurn") ~= true then
    return
  end

  local owned = system.getStorage("main:ownedPercentage")

  local t = main.printRichText({
    format=owned/100 .. "X",
    x=1100,
    y=200,
    renderLayer=200,
    font = biggerFont
  })
  t.x = t.x - t.richText:getWidth()/2
end)

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
    local flux = system.getStorage("flux")
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

makeJuice(pointText, "main:currentPriceChanged")
makeJuice(multText, "main:multChanged")