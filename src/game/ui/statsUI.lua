local defaultPoint = 0
local point = system.getStorage("main:point")
local pointText = main.newRichText({format="Point: " ..  math.floor(point-defaultPoint+0.5) .. "",
  y=200,
  x=60,
  renderLayer = 200,})

local money = main.getMoney()
local moneyText = main.newRichText({format="Money: {moneyColor}" .. money .. "{/moneyColor}",
  y=200,
  x=60,
  renderLayer = 200,})

--point text
system.on("main:pointChanged", function ()
  local point = system.getStorage("main:point")
  main.updateRichTextText(pointText, "Point: " .. math.floor(point-defaultPoint+0.5) .. "")
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