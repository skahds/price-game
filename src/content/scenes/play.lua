local cover
local ownSlider
local scaleYSlider
local startTurn
local chart

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("play", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20}, true)
  ownSlider = main.ui.spawnUI("ownSlider", {x=50, y=10}, true)
  scaleYSlider = main.ui.spawnUI("scaleYSlider", {x=1050, y=30}, true)
  startTurn = main.ui.spawnUI("startTurn", {x=80, y=450}, true)
  -- spawnCard = main.ui.spawnUI("spawnCard", {x=80, y=350}, true)
  -- back = main.ui.spawnUI("backToMenu", {x=300, y=350}, true)
  main.spawnChart({bearPower = 0.2, bullPower = 0.2})
  chart = system.getStorage("main:chart")

  main.drawCardTillMaxCapacity()
end, function ()
  local endStats = {
    finalPoint = system.getStorage("main:point"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, ownSlider, scaleYSlider, startTurn, chart})
end)