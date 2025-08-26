local biggerFont = system.getFont("defaultFont100")
local point = system.getStorage("main:point")
local pointText = main.newRichText({format="Point: " ..  math.floor(point+0.5) .. "",
  y=200,
  x=60,
  renderLayer = 200,})

local money = main.getMoney()
local moneyText = main.newRichText({format="Money: {moneyColor}" .. money .. "{/moneyColor}",
  y=200,
  x=60,
  renderLayer = 200,})

local multText = main.newRichText({format="{brightRedColor}X" ..  math.floor(0+0.5) .. "{/brightRedColor}",
  y=300,
  x=300,
  renderLayer = 200,
  font = biggerFont,
  })

local currentPointText = main.newRichText({format="{pointColor}" ..  math.floor(0+0.5) .. "{/pointColor}",
  y=300,
  x=100,
  renderLayer = 200,
  font = biggerFont})

--point text
system.on("main:pointChanged", function ()
  local point = system.getStorage("main:point")
  main.updateRichTextText(pointText, "Point: " .. math.floor(point+0.5) .. "")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    pointText.x = -2000
  end
  if scene == "play" then
    pointText.x = 60
  end
end)

--money text
system.on("main:moneyChanged", function ()
  local money = main.getMoney()
  main.updateRichTextText(moneyText, "Money: {moneyColor}" .. math.floor(money) .. "{/moneyColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "shop" then
    moneyText.x = -2000
  end
  if scene == "shop" then
    moneyText.x = 60
  end
end)

-- mult text
system.on("@update", function ()
  local mult = system.getStorage("main:mult")
  main.updateRichTextText(multText, "{brightRedColor}X" ..  math.floor(mult+0.5) .. "{/brightRedColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    multText.x = -2000
  end
  if scene == "play" then
    multText.x = 300
  end
end)

-- currentPointText
local currentPoint = 0
system.on("main:currentPriceChanged", function (bar)
  currentPoint = bar.endPrice - bar.startPrice
  main.updateRichTextText(currentPointText, "{pointColor}" ..  math.floor(currentPoint+0.5) .. "{/pointColor}")
end)

system.on("main:endTurn", function ()
  currentPoint = 0
  main.updateRichTextText(currentPointText, "{pointColor}0{/pointColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    currentPointText.x = -2000
  end
  if scene == "play" then
    currentPointText.x = 100
  end
end)