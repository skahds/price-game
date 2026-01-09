local flux = system.getStorage("flux")
local pipeline = main.getPipeline("main")
local patternsUI
local existingUI = {}
local leftStartX = 640-300
local y = 640*2/5
local patternSelected
local cardOptionsUI = {}
local patternCardSelectedIndex = 1

local greenColor, redColor = {0.2, 0.8, 0.2}, {0.8, 0.2, 0.2}
local renderLayer=120
-- choose a bar to add! x2 mult or smth
-- remove a bar! x0.7 mult or smth

local function format(n)
  if n > 0 then
    return "+" .. n
  else
    return n
  end
end

--[[ todo:
- choose which patterns to edit, wether new or replace
- don't show and delete every frame, just show once and change stuff around normally
- fluxes and animation so it doesn't look bad
]]

local function setRandomPattern()
  local listOfPattern = main.getPatternsTable()
  local newPattern = listOfPattern[love.math.random(1, #listOfPattern)]
  if #listOfPattern > 1 then
    while newPattern == patternSelected do
      newPattern = listOfPattern[love.math.random(1, #listOfPattern)]
    end
  end

  patternSelected = newPattern
end

function main.createRewardsEditPattern()
  local cards = main.getRandomPatternsCard{amount=3}
  for i, cardT in ipairs(cards) do
    local card = main.spawnPatternsCard(cardT.id, {})
    local ui = main.createPatternsUIForCard(card)
    table.insert(cardOptionsUI, ui)
    ui.toBeChosen = true
    ui.x = 640+400
    ui.y = 360+(i-2)*150-ui:getWidth()/2
  end

  setRandomPattern()
end

function main.clearRewardEditPattern()
  for i, ui in ipairs(existingUI) do
    ui:delete()
  end

  for i=#cardOptionsUI, 1, -1 do
    pipeline:add(0.15, function ()
      local card = cardOptionsUI[i].parent
      local ui = cardOptionsUI[i]
      ui:delete()
      card:delete()
    end)
  end

  main.wait(0.5, function ()
    patternSelected = nil
  end)
end

system.on("main:patterns_uiClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil or ent.canBeSelected == false or ent.toBeChosen ~= true then
    return
  end

  for i, card in ipairs(cardOptionsUI) do
    card.toBeChosen = false
  end

  table.insert(patternSelected.sequence, ent.parent)
  for i, card in ipairs(cardOptionsUI) do
    if card == ent then
      table.remove(cardOptionsUI, i)
      break
    end
  end
  ent:delete()

  main.clearRewardEditPattern()
end)

system.on("@update", function ()
  if patternsUI then
    main.hidePatterns(patternsUI)
  end

  if patternSelected == nil then
    return
  end

  local pattern = patternSelected

  local t = main.printRichText({
    format = "Choose a pattern card to add!",
    renderLayer = renderLayer+1,
    x=650,
    y=30,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2

  local t = main.printRichText({
    format = pattern.name,
    renderLayer = renderLayer+1,
    x=leftStartX,
    y=100,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2
  local t = main.printRichText({
    format = "{priceColor}" .. format(pattern.price) .. "{priceIcon}{/priceColor} {multColor}" .. format(pattern.mult) .. "{multIcon}",
    renderLayer = renderLayer+1,
    x=leftStartX,
    y=100,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y + t.richText:getHeight()

  patternsUI = main.showPatterns(pattern, {x=leftStartX, y=360}, 300)
end)

system.on("@draw", function ()
  if patternSelected == nil then
    return
  end

  system.render(150, function ()
    for i, card in ipairs(patternsUI) do
      if i == 1 then goto continue end

      local previousCard = patternsUI[i-1]
      local gap = card.x - (previousCard.x + previousCard:getWidth())
      local averageY = (system.ask("ui:getUIY", combiner.ADD, card)
      + system.ask("ui:getUIY", combiner.ADD, previousCard))/2 + card:getHeight()/2

      love.graphics.draw(system.getImage("patternsDivider"), card.x - gap/2, averageY, 0, 1.4, 1.4, 2, 43)

      ::continue::
    end
  end, true)
end)