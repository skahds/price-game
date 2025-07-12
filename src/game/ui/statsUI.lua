local defaultMoney = 100
local moneyText = main.newRichText({format="Point: {moneyColor}" .. 0 .. "{/moneyColor}",
  y=200,
  x=60,
  renderLayer = 200,})

-- system.on("@renderer:render", function ()
--   if system.getStorage("main:currentScene") ~= "play" then
--     return
--   end
--   system.render(200, function ()
--     local money = system.getStorage("main:money")
--     if money then
--       love.graphics.print("$" .. math.floor(money+0.5), 80, 200)
--     end
--   end, true)
-- end)
system.on("main:moneyChanged", function ()
  local money = system.getStorage("main:money")
  main.updateRichTextText(moneyText, "Point: {moneyColor}" .. math.floor(money-defaultMoney+0.5) .. "{/moneyColor}")
end)

system.on("main:sceneChanged", function()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    moneyText.x = -2000
  end
  print("scene", scene)
  if scene == "play" then
    moneyText.x = 60
  end
end)