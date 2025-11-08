local cover
-- local ownSlider
local scaleYSlider
local sell
local buy

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

-- card is not relic anymore, only news are relic

-- local function drawAllRelics()
--   local pipeline = main.getPipeline("main")
--   local maxCard = system.getStorage("main:maxCardAmount")
--   for i=#main.card.draw, 1, -1 do
--     local card = main.card.draw[i]
--     local currentSpace = main.getCurrentCardInHandAmount()
--     local space = system.ask("main:cardSpaceUsed", combiner.ADD, card)
--     if currentSpace + space <= maxCard then
--       if card.isRelic == true then
--         pipeline:add(0.25, function ()
--           main.cardToHand(card)
--         end)
--       end
--     end
--   end
-- end

main.defineScene("play", function ()

  local dimension = system.getStorage("screenDimension")
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=350, height=360,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=10, rx=20, ry=20}, true)
  
  sell = main.ui.spawnUI("startTurn", {x=640-85-75, y=50, mult=-1, color={0.7, 0.4, 0.4}}, true)
  main.updateRichTextText(sell.richtext, "DOWN")
  buy = main.ui.spawnUI("startTurn", {x=640+85-75, y=50, color={0.4, 0.7, 0.4}}, true)
  main.updateRichTextText(buy.richtext, "UP")

  main.drawCardTillMaxCapacity()
  main.spawnBarChangeNews()

  for i, card in ipairs(main.card.hand) do
    card.isLocked = false
  end
  for i, card in ipairs(main.card.draw) do
    card.isLocked = false
  end
  for i, card in ipairs(main.card.discard) do
    card.isLocked = false
  end
  main.showCharts()
end, function ()
  local chart = system.getStorage("main:chart")
  system.updateStorage("main:currentDay", system.getStorage("main:currentDay")+1)
  local endStats = {
    finalScore = system.getStorage("main:score"),
    barsTaken = #chart.bars
  }
  system.updateStorage("main:endLevelStats", endStats)
  deleteAll({cover, scaleYSlider, sell, buy})
  chart:clear()

  local bar = main.spawnBar()
  system.updateStorage("main:ownedPercentage", 0)

  for i, card in ipairs(main.card.hand) do
    card.isLocked = true
  end
  for i, card in ipairs(main.card.draw) do
    card.isLocked = true
  end
  for i, card in ipairs(main.card.discard) do
    card.isLocked = true
  end
end)