local patterns = {
  -- {id="crows", name="Crows", sequence={"positive", "smallernegative", "smallerpositive", mult=10, price=20}}
}

--spawnPatternsCard("anynegative", ..)
function main.definePatternsCard(id, eType)
  id = "patterns" .. id
  eType.id = id
  eType.isPatternsCard = true
  eType.defaultMultGain = eType.defaultMultGain or 1
  eType.defaultPriceGain = eType.defaultPriceGain or 0
  eType.priceMultiplier = eType.priceMultiplier or 1
  eType.multMultiplier = eType.multMultiplier or 1
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
end

function main.spawnPatternsCard(id, args)
  local card = main.spawnEntity("patterns" .. id, args)
  -- table.insert(main.card[ownerShip], card)
  -- card.cardOrder = #main.card[ownerShip]
  -- card.ownerShip = ownerShip
  -- card.ui.isVisible = false
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
    return math.abs(a.mult*a.price) > math.abs(b.mult*b.price)
  end)
end

--this creates a set of ui
function main.showPatterns(pattern, location, renderLayer)
  local listOfPatternsUI = {}
  local totalWidth = 0
  local gap = location.gap or 10
  for i, card in ipairs(pattern.sequence) do
    local image = card.image or "blank_card"
    local ui = main.ui.spawnUI("patterns_ui", {image=image, x=card.x, y=card.y})
    table.insert(listOfPatternsUI, ui)
    ui.parent = card
    ui.renderLayer = renderLayer or ui.renderLayer

    totalWidth = totalWidth + ui:getWidth()
    if i ~= 0 then
      totalWidth = totalWidth + gap
    end
  end

  for i, ui in ipairs(listOfPatternsUI) do
    ui.x = location.x - totalWidth/2 + (i-1)*(ui:getWidth()+gap)
    ui.y = location.y - ui:getHeight()/2
  end

  return listOfPatternsUI
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
    local currentLength = #currentSequence
    
    -- Check if we have enough bars to match the pattern
    if currentLength >= sequenceLength then
      local matches = true
      
      -- Check the last N elements of currentSequence against the pattern
      for j = 1, sequenceLength do
        local currentIndex = currentLength - sequenceLength + j
        local patternItem = pattern.sequence[j].pattern
        local currentItem = currentSequence[currentIndex]
        
        -- Check for "any" prefix
        if patternItem:sub(1, 3) == "any" then
          -- Extract the suffix (e.g., "negative" from "anynegative")
          local suffix = patternItem:sub(4) or ""
          -- Check if current item ends with the suffix
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
  for i, card in ipairs(pattern.sequence) do
    if card.defaultPriceGain then
      pattern.price = pattern.price + card.defaultPriceGain
    end
    if card.defaultMultGain then
      pattern.mult = pattern.mult + card.defaultMultGain
    end
    if card.priceMultiplier then
      pattern.price = pattern.price * card.priceMultiplier
    end
    if card.multMultiplier then
      pattern.mult = pattern.mult * card.multMultiplier
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
  priceMultiplier = 2,
})

main.definePatternsCard("biggerpositive", {
  name = "Bigger Positive",
  image= "patternsBiggerPositive",
  pattern="biggerpositive",
  priceMultiplier = 2,
})

main.definePatternsCard("smallerpositive", {
  name = "Smaller Positive",
  image= "patternsSmallerPositive",
  pattern="smallerpositive",
  multMultiplier = 2,
})

main.definePatternsCard("anynegative", {
  name = "Any Negative",
  image= "patternsAnyNegative",
  pattern="anynegative",
  priceMultiplier = 2,
})

main.definePatternsCard("biggernegative", {
  name = "Bigger Negative",
  image= "patternsBiggerNegative",
  pattern="biggernegative",
  priceMultiplier = 2,
})

main.definePatternsCard("smallernegative", {
  name = "Smaller Negative",
  image= "patternsSmallerNegative",
  pattern="smallernegative",
  multMultiplier = 2,
})

main.definePatternsCard("placeholder", {
  name = "Placeholder",
  image= "patternsPlaceholder",
  defaultMultGain=0,
})

function main.resetPatterns()
  patterns = {}
  --positive
  main.createPattern({id="star", name="Star", sequence={"anynegative", "smallernegative", "biggerpositive"}, defaultMult=4, defaultPrice=20})
  main.createPattern({id="soliders", name="Soliders", sequence={"anypositive", "anypositive", "anypositive"}, defaultMult=3, defaultPrice=12})
  main.createPattern({id="upReversal", name="Up Reversal", sequence={"anynegative", "smallerpositive"}, defaultMult=2, defaultPrice=8})
  main.createPattern({id="upEngulf", name="Up Engulf", sequence={"anynegative", "biggerpositive"}, defaultMult=2, defaultPrice=6})
  main.createPattern({id="upCandle", name="Up Candle", sequence={"anypositive"}, defaultMult=1, defaultPrice=2})


  --negative
  main.createPattern({id="moon", name="Moon", sequence={"anypositive", "smallerpositive", "biggernegative"}, defaultMult=4, defaultPrice=-20})
  main.createPattern({id="crows", name="Crows", sequence={"anynegative", "anynegative", "anynegative"}, defaultMult=3, defaultPrice=-12})
  main.createPattern({id="downReversal", name="Down Reversal", sequence={"anypositive", "smallernegative"}, defaultMult=2, defaultPrice=-8})
  main.createPattern({id="downEngulf", name="Down Engulf", sequence={"anypositive", "biggernegative"}, defaultMult=2, defaultPrice=-6})
  main.createPattern({id="downCandle", name="Down Candle", sequence={"anynegative"}, defaultMult=1, defaultPrice=-2})

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