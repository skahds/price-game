local font = system.getFont("defaultFont60")
local cover
local continueToShop
local stats = {}


local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("levelEnd", function ()
  local pipeline = main.getPipeline("main")

  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20}, true)
  continueToShop = main.ui.spawnUI("continueToShop", {x=70, y=310}, true)

  local finalStats = system.getStorage("main:endLevelStats")
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local t = {}
  table.insert(t, "Total point: " .. finalStats.finalPoint)
  table.insert(t, "Turn played: " .. finalStats.barsTaken)

  local money = roundsRemaining + 3
  if money < 10 then
    local text = "Money Earned: {moneyColor}"
    for i=1, money do
      text = text .. "$"
    end
    table.insert(t, text)
  else
    table.insert(t, "Money Earned: {moneyColor}$" .. money)
  end
    

  local height = font:getHeight()

  for i, format in ipairs(t) do
    pipeline:add(0.2, function ()
      table.insert(stats, main.newRichText({
        format = format,
        x=500,
        y=200+height*(i-1),
      }))
    end)
  end

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end

  for i=1, money do
    pipeline:add(0.1, function ()
      main.addMoney(1)
    end)
  end
  system.updateStorage("main:point", 0)
end, function ()

  deleteAll({cover, continueToShop})
  deleteAll(stats)
end)