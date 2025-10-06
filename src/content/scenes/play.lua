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

local function drawAllRelics()
  local pipeline = main.getPipeline("main")
  local maxCard = system.getStorage("main:maxCardAmount")
  for i=#main.card.draw, 1, -1 do
    local card = main.card.draw[i]
    local space = system.ask("main:cardSpaceUsed", combiner.ADD, card)
    if space and #main.card.hand + space <= maxCard then
      if card.isRelic == true then
        pipeline:add(0.15, function ()
          main.cardToHand(card)
        end)
      end
    end
  end
end

main.defineScene("play", function ()
  local dimension = system.getStorage("screenDimension")
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20}, true)
  ownSlider = main.ui.spawnUI("ownSlider", {x=dimension.w/2-200, y=30}, true)
  -- scaleYSlider = main.ui.spawnUI("scaleYSlider", {x=1050, y=30}, true)
  startTurn = main.ui.spawnUI("startTurn", {x=80, y=350}, true)
  -- spawnCard = main.ui.spawnUI("spawnCard", {x=80, y=350}, true)
  -- back = main.ui.spawnUI("backToMenu", {x=300, y=350}, true)
  main.spawnChart({bearPower = 0.2, bullPower = 0.2})
  chart = system.getStorage("main:chart")

  local bar = main.spawnBar()
  system.updateStorage("main:currentBar", bar)

  -- draw all relics
  drawAllRelics()
  
  local pos = chart:getCurrentPricePos()
  main.spawnNews("randomEvents", {x=pos.x-128, y=pos.y-32})

  main.drawCardTillMaxCapacity()
end, function ()
  local endStats = {
    finalPoint = system.getStorage("main:point"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, ownSlider, scaleYSlider, startTurn, chart})
end)