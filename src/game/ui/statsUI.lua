local biggerFont = system.getFont("defaultFont100")
local point = system.getStorage("main:point")
local pointText = main.newRichText({format="Points: " ..  math.floor(point+0.5) .. "",
  y=130,
  x=70,
  renderLayer = 200,})

local money = main.getMoney()
local moneyText = main.newRichText({format="{moneyColor}$" .. money .. "{/moneyColor}",
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

local currentPointText = main.newRichText({format="{pointColor}" ..  math.floor(0+0.5) .. "{/pointColor}",
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

--point text
system.on("main:pointChanged", function ()
  local point = system.getStorage("main:point")
  local pointRequired = system.getStorage("main:pointRequirement")
  main.updateRichTextText(pointText, "Points: " .. math.floor(point+0.5) .. "/" .. pointRequired)
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    pointText.x = -2000
  end
  if scene == "play" then
    local pointRequired = system.getStorage("main:pointRequirement")
    main.updateRichTextText(pointText, "Point: " .. math.floor(point+0.5) .. "/" .. pointRequired)
    pointText.x = 70
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

-- currentPointText
-- local currentPoint = 0
system.on("@update", function ()
  local bar = system.getStorage("main:currentBar")
  if bar then
    local currentPoint = bar.endPrice - bar.startPrice
    main.updateRichTextText(currentPointText, "{pointColor}" ..  math.floor(currentPoint+0.5) .. "{/pointColor}")
  end
end)

-- system.on("main:endTurn", function ()
--   currentPoint = 0
--   main.updateRichTextText(currentPointText, "{pointColor}0{/pointColor}")
-- end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    currentPointText.x = -2000
  end
  if scene == "play" then
    currentPointText.x = 1100
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

makeJuice(currentPointText, "main:currentPriceChanged")
makeJuice(multText, "main:multChanged")