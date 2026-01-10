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
  table.insert(patternSelected.sequence, main.spawnPatternsCard("selectAdd", {}))

  if patternsUI then
    main.hidePatterns(patternsUI)
  end

  patternsUI = main.showPatterns(patternSelected, {x=leftStartX, y=360, renderLayer=renderLayer})
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

  for _, pattern in pairs(main.getPatternsTable()) do
    for i=#pattern.sequence, 1, -1 do
      local card = pattern.sequence[i]
      if card.id == "patternsselectAdd" then
        table.remove(pattern.sequence, i)
        card:delete()
      end
    end
  end

  main.wait(0.5, function ()
    patternSelected = nil
  end)
end

system.on("main:patterns_uiClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.toBeChosen then
    for i, card in ipairs(cardOptionsUI) do
      card.toBeChosen = false
    end

    local seq = patternSelected.sequence
    -- table.insert(patternSelected.sequence, ent.parent)
    local currentCard = seq[patternCardSelectedIndex]
    seq[patternCardSelectedIndex] = ent.parent
    currentCard:delete()

    for i, card in ipairs(cardOptionsUI) do
      if card == ent then
        table.remove(cardOptionsUI, i)
        break
      end
    end
    ent:delete()

    main.clearRewardEditPattern()
  else
    for i, card in ipairs(patternsUI) do
      if card == ent then
        patternCardSelectedIndex = i
      end
    end
  end
end)

system.on("@update", function ()
  -- if patternsUI then
  --   main.hidePatterns(patternsUI)
  -- end

  if patternSelected == nil then
    if patternsUI then
      main.hidePatterns(patternsUI)
    end
    return
  end

  local pattern = patternSelected

  local t = main.printRichText({
    format = "Choose a pattern card to replace/add!",
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
end)

system.on("@draw", function ()
  if patternSelected == nil then
    return
  end

  system.render(150, function ()
    for i, card in ipairs(patternsUI) do
      local y1 = system.ask("ui:getUIY", combiner.ADD, card)
      love.graphics.setColor(1, 1, 1)

      if patternCardSelectedIndex == i then
        -- to be fluxed
        love.graphics.draw(system.getImage("patternsSelectArrow"), card.x + card:getWidth()/2, y1 + card:getHeight()+30, 0, 1.4, 1.4, 22, 12)
      end

      if i == 1 then goto continue end

      love.graphics.setColor(1, 1, 1)
      local previousCard = patternsUI[i-1]
      local gap = card.x - (previousCard.x + previousCard:getWidth())
      local averageY = (y1 + system.ask("ui:getUIY", combiner.ADD, previousCard))/2 + card:getHeight()/2

      love.graphics.draw(system.getImage("patternsDivider"), card.x - gap/2, averageY, 0, 1.4, 1.4, 2, 43)

      ::continue::
    end
  end, true)
end)