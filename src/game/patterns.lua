local flux = system.getStorage("flux")
local patterns = {
  -- {id="crows", name="Crows", sequence={"positive", "smallernegative", "smallerpositive", mult=10, price=20}}
}
main.patternsCardEntities = {}

--spawnPatternsCard("anynegative", ..)
function main.definePatternsCard(id, eType)
  id = "patterns" .. id
  eType.id = id
  eType.isPatternsCard = true
  eType.defaultMultGain = eType.defaultMultGain or 1
  eType.defaultPriceGain = eType.defaultPriceGain or 0
  eType.defaultPriceMultiplier = eType.defaultPriceMultiplier or 1
  eType.defaultMultMultiplier = eType.defaultMultMultiplier or 1
  main.entities[id] = class(main.entities.basicEnt)
  local card = main.entities[id]
  local basicEnt = main.entities.basicEnt

  function card:init(args)
    basicEnt.init(self, args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    -- no self.ui, but the ui's that exist reference self as parent
  end

  function card:update()
    if self.onUpdate then
      self:onUpdate()
    end
  end

  function card:draw(args)

  end

  card.definition = eType
  card.id = id
  table.insert(main.patternsCardEntities, card)
end

function main.getRandomPatternsCard(info)
  info.amount = info.amount or 1
  local t = {}
  local listOfCards = {}
  for i, card in ipairs(main.patternsCardEntities) do
    if card.definition.ignoreForPick ~= true then
      if info.category == nil or info.category == card.definition.category then
        table.insert(listOfCards, card)
      end
    end
  end


  for i=1, info.amount do
    local index = love.math.random(1, #listOfCards)
    local card = listOfCards[index]
    table.insert(t, card)
    table.remove(listOfCards, index)
  end

  return t
end

function main.spawnPatternsCard(id, args)
  id = id:gsub("patterns", "")
  local card = main.spawnEntity("patterns" .. id, args)
  return card
end

local currentSequence = {}
system.on("@update", function ()
  local chart = system.getStorage("main:chart")
  if chart == nil then
    return
  end

  currentSequence = {}

  for i, bar in ipairs(chart.bars) do
    local text = ""
    local comparePrice = 0
    local price = bar.endPrice - bar.startPrice
    local previousBar = chart.bars[i-1]
    if previousBar then
      comparePrice = previousBar.endPrice - previousBar.startPrice
    end

    if math.abs(price) < math.abs(comparePrice) then
      text = "smaller"
    else
      text = "bigger"
    end

    if price > 0 then
      text = text .. "positive"
    elseif price < 0 then
      text = text .. "negative"
    elseif price == 0 then
      text = "neutral"
    end
    currentSequence[i] = text
  end
end)

function main.createPattern(t)
  local fixSequence = {}
  local firstCard = main.spawnPatternsCard("placeholder", {})
  table.insert(fixSequence, firstCard)
  firstCard.name=t.name
  firstCard.defaultPriceGain=t.defaultPrice
  firstCard.defaultMultGain=t.defaultMult

  for i, seq in ipairs(t.sequence) do
    table.insert(fixSequence, main.spawnPatternsCard(seq, {}))
  end
  t.sequence = fixSequence

  main.resultOfPattern(t)

  table.insert(patterns, t)
  table.sort(patterns, function (a, b)
    return math.abs((a.mult+1)*a.price) > math.abs((b.mult+1)*b.price)
  end)
end

function main.createPatternsUIForCard(card)
  local image = card.image or "blank_card"
  local ui = main.ui.spawnUI("patterns_ui", {image=image, x=card.x, y=card.y})
  ui.parent = card
  return ui
end

--this creates a set of ui
function main.showPatterns(pattern, info)
  local listOfPatternsUI = {}
  local totalWidth = 0
  local gap = info.gap or 10
  local showSequence = {}
  for i, card in ipairs(pattern.sequence) do
    if card.ignoreDefaultShown ~= true then
      table.insert(showSequence, card)
    elseif card.ignoreDefaultShown == true and info.showAllCards == true then
      table.insert(showSequence, card)
    end
  end

  for i, card in ipairs(showSequence) do
    local image = card.image or "blank_card"
    local ui = main.ui.spawnUI("patterns_ui", {image=image, x=card.x, y=card.y})
    table.insert(listOfPatternsUI, ui)
    ui.parent = card
    ui.renderLayer = info.renderLayer or ui.renderLayer

    totalWidth = totalWidth + ui:getWidth()
    if i ~= 0 then
      totalWidth = totalWidth + gap
    end
  end

  for i, ui in ipairs(listOfPatternsUI) do
    ui.x = info.x - totalWidth/2 + (i-1)*(ui:getWidth()+gap)
    ui.y = info.y - ui:getHeight()/2
  end

  return listOfPatternsUI
end

function main.movePatternsUIToPosition(patternUI, info)
  

  local totalWidth = 0
  local gap = info.gap or 10
  for i, ui in ipairs(patternUI) do
    totalWidth = totalWidth + ui:getWidth()
    if i ~= 0 then
      totalWidth = totalWidth + gap
    end
  end

  for i, ui in ipairs(patternUI) do
    flux.to(ui, info.time or 0.3, {
      x = info.x - totalWidth/2 + (i-1)*(ui:getWidth()+gap),
      y = info.y - ui:getHeight()/2
    }):ease(info.ease or "quadout")
  end
end

function main.hidePatterns(t)
  for i=#t, 1, -1 do
    local ui = t[i]
    ui:delete()
  end
end

function main.getCurrentPattern()
  for i, pattern in ipairs(patterns) do
    local sequenceLength = #pattern.sequence
    local realLength = 0

    -- Count non-nil patterns
    for e, card in ipairs(pattern.sequence) do
      if card.pattern then
        realLength = realLength + 1
      end
    end
    
    local currentLength = #currentSequence
    
    -- Check if we have enough bars to match the pattern
    if currentLength >= realLength then

      local matches = true
      local currentOffset = 0  -- Track position in currentSequence
      -- Check pattern against currentSequence
      for j = 1, sequenceLength do
        local patternItem = pattern.sequence[j].pattern
        
        -- Skip nil pattern items
        if patternItem == nil then
          currentOffset = currentOffset + 1
          goto continue
        end
        -- Calculate the actual index in currentSequence
        local currentIndex = currentLength - realLength + j - currentOffset
        local currentItem = currentSequence[currentIndex]
        
        -- Check for "any" prefix
        if patternItem:sub(1, 3) == "any" then
          local suffix = patternItem:sub(4) or ""
          if not currentItem:match(suffix .. "$") then
            matches = false
            break
          end
        else
          -- Exact match required
          if currentItem ~= patternItem then
            matches = false
            break
          end
        end
        
        ::continue::
      end
      
      if matches then
        return pattern
      end
    end
  end
  
  return nil
end

function main.resultOfPattern(pattern)
  pattern.price = 0
  pattern.mult = 0
  pattern.money = 0
  pattern.realPatternLength = 0
  for i, card in ipairs(pattern.sequence) do
    if card.pattern then
      pattern.realPatternLength = pattern.realPatternLength + 1
    end

    if card.defaultPriceGain then
      pattern.price = pattern.price + card.defaultPriceGain
    end
    if card.defaultMultGain then
      pattern.mult = pattern.mult + card.defaultMultGain
    end
    if card.defaultPriceMultiplier then
      pattern.price = pattern.price * card.defaultPriceMultiplier
    end
    if card.defaultMultMultiplier then
      pattern.mult = pattern.mult * card.defaultMultMultiplier
    end
    if card.defaultMoneyGain then
      pattern.money = pattern.money + card.defaultMoneyGain
    end
  end
end

function main.activatePattern(pattern)
  main.resultOfPattern(pattern)
  main.addMult(pattern.mult)
  main.addPrice(pattern.price)
  main.addMoney(pattern.money)
  for i, card in ipairs(pattern.sequence) do
    if card.onActivate then
      card:onActivate()
    end
  end
end

function main.getPatternsTable()
  return patterns
end

main.definePatternsCard("anypositive", {
  name = "Any Positive",
  image= "patternsAnyPositive",
  pattern="anypositive",
  defaultPriceMultiplier = 2,
  category="default",
})

main.definePatternsCard("biggerpositive", {
  name = "Bigger Positive",
  image= "patternsBiggerPositive",
  pattern="biggerpositive",
  defaultPriceMultiplier = 2,
  category="default",
})

main.definePatternsCard("smallerpositive", {
  name = "Smaller Positive",
  image= "patternsSmallerPositive",
  pattern="smallerpositive",
  defaultMultMultiplier = 1.5,
  category="default",
})

main.definePatternsCard("anynegative", {
  name = "Any Negative",
  image= "patternsAnyNegative",
  pattern="anynegative",
  defaultPriceMultiplier = 2,
  category="default",
})

main.definePatternsCard("biggernegative", {
  name = "Bigger Negative",
  image= "patternsBiggerNegative",
  pattern="biggernegative",
  defaultPriceMultiplier = 2,
  category="default",
})

main.definePatternsCard("smallernegative", {
  name = "Smaller Negative",
  image= "patternsSmallerNegative",
  pattern="smallernegative",
  defaultMultMultiplier = 1.5,
  category="default",
})

main.definePatternsCard("placeholder", {
  name = "Placeholder",
  image= "patternsDefault",
  defaultMultGain=0,
  ignoreForPick = true
})

function main.resetPatterns()
  patterns = {}
  --positive
  main.createPattern({id="star", name="Star", sequence={"anynegative", "smallernegative", "biggerpositive"}, defaultMult=0, defaultPrice=3})
  main.createPattern({id="soliders", name="Soliders", sequence={"anypositive", "anypositive", "anypositive"}, defaultMult=0, defaultPrice=1})
  main.createPattern({id="upReversal", name="Up Reversal", sequence={"anynegative", "smallerpositive"}, defaultMult=0, defaultPrice=2})
  main.createPattern({id="upEngulf", name="Up Engulf", sequence={"anynegative", "biggerpositive"}, defaultMult=0, defaultPrice=2})
  main.createPattern({id="upCandle", name="Up Candle", sequence={"anypositive"}, defaultMult=0, defaultPrice=3})


  --negative
  main.createPattern({id="moon", name="Moon", sequence={"anypositive", "smallerpositive", "biggernegative"}, defaultMult=0, defaultPrice=-3})
  main.createPattern({id="crows", name="Crows", sequence={"anynegative", "anynegative", "anynegative"}, defaultMult=0, defaultPrice=-1})
  main.createPattern({id="downReversal", name="Down Reversal", sequence={"anypositive", "smallernegative"}, defaultMult=0, defaultPrice=-2})
  main.createPattern({id="downEngulf", name="Down Engulf", sequence={"anypositive", "biggernegative"}, defaultMult=0, defaultPrice=-2})
  main.createPattern({id="downCandle", name="Down Candle", sequence={"anynegative"}, defaultMult=0, defaultPrice=-3})

  for i, pattern in ipairs(patterns) do
    main.resultOfPattern(pattern)
  end
end

system.register("patterns", 18, function ()
  return patterns
end, function (t)
  patterns = t
end)

system.on("@load", function ()
  main.resetPatterns()
end)