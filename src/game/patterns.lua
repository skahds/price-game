local currentlyVisiblePatterns = {}

local patterns = {
  -- {id="crows", name="Crows", sequence={"positive", "smallernegative", "smallerpositive", mult=10, price=20}}
}

--spawnPatternsCard("anynegative", ..)
function main.definePatternsCard(id, eType)
  id = "patterns" .. id
  eType.id = id
  eType.isPatternsCard = true
  eType.defaultMultGain = eType.defaultMultGain or 5
  eType.defaultPriceGain = eType.defaultPriceGain or 1
  main.entities[id] = class(main.entities.basicEnt)
  local card = main.entities[id]
  local basicEnt = main.entities.basicEnt

  function card:init(args)
    basicEnt.init(self, args)
    for k, v in pairs(eType) do
      self[k] = utils.deepCopy(v)
    end

    local image = self.image or "blank_card"
    
    self.ui = main.ui.spawnUI("patterns_ui", {image=image, x=self.x, y=self.y})
    self.ui.parent = self

    self.pattern = self.pattern or "any"
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
  card.ui.isVisible = false
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
  for i, seq in ipairs(t.sequence) do
    table.insert(fixSequence, main.spawnPatternsCard(seq, {}))
  end
  t.sequence = fixSequence

  table.insert(patterns, t)
  table.sort(patterns, function (a, b)
    return math.abs(a.mult*a.price) > math.abs(b.mult*b.price)
  end)
end

function main.showPatterns(pattern, location, renderLayer)
  local totalWidth = 0
  local gap = location.gap or 10
  for i, card in ipairs(pattern.sequence) do
    card.ui.renderLayer = renderLayer or card.ui.renderLayer
    card.ui.isVisible = true
    table.insert(currentlyVisiblePatterns, card)
    totalWidth = totalWidth + card.ui:getWidth()
    if i ~= 0 then
      totalWidth = totalWidth + gap
    end
  end

  for i, card in ipairs(pattern.sequence) do
    card.ui.x = location.x - totalWidth/2 + (i-1)*card.ui:getWidth()+gap
    card.ui.y = location.y
  end
end

function main.hideAllPatterns()
  for i, card in pairs(currentlyVisiblePatterns) do
    card.ui.isVisible = false
  end

  currentlyVisiblePatterns = {}
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
        local patternItem = pattern.sequence[j]
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

function main.getPatternsTable()
  return patterns
end

main.definePatternsCard("anypositive", {
  name = "Any Positive",
  image= "patternsAnyPositive",
})

main.definePatternsCard("biggerpositive", {
  name = "Bigger Positive",
  image= "patternsBiggerPositive",
})

main.definePatternsCard("smallerpositive", {
  name = "Any Positive",
  image= "patternsSmallerPositive",
})

main.definePatternsCard("anynegative", {
  name = "Any Negative",
  image= "patternsAnyNegative",
})

main.definePatternsCard("biggernegative", {
  name = "Bigger Negative",
  image= "patternsBiggerNegative",
})

main.definePatternsCard("smallernegative", {
  name = "Smaller Negative",
  image= "patternsSmallerNegative",
})

function main.resetPatterns()
  patterns = {}
  --positive
  main.createPattern({id="star", name="Star", sequence={"anynegative", "smallernegative", "biggerpositive"}, mult=4, price=20})
  main.createPattern({id="soliders", name="Soliders", sequence={"anypositive", "anypositive", "anypositive"}, mult=3, price=12})
  main.createPattern({id="upReversal", name="Up Reversal", sequence={"anynegative", "smallerpositive"}, mult=2, price=8})
  main.createPattern({id="upEngulf", name="Up Engulf", sequence={"anynegative", "biggerpositive"}, mult=2, price=6})
  main.createPattern({id="upCandle", name="Up Candle", sequence={"anypositive"}, mult=1, price=2})


  --negative
  main.createPattern({id="moon", name="Moon", sequence={"anypositive", "smallerpositive", "biggernegative"}, mult=4, price=-20})
  main.createPattern({id="crows", name="Crows", sequence={"anynegative", "anynegative", "anynegative"}, mult=3, price=-12})
  main.createPattern({id="downReversal", name="Down Reversal", sequence={"anypositive", "smallernegative"}, mult=2, price=-8})
  main.createPattern({id="downEngulf", name="Down Engulf", sequence={"anypositive", "biggernegative"}, mult=2, price=-6})
  main.createPattern({id="downCandle", name="Down Candle", sequence={"anynegative"}, mult=1, price=-2})
end

system.register("patterns", 18, function ()
  return patterns
end, function (t)
  patterns = t
end)

system.on("@load", function ()
  main.resetPatterns()
  main.wait(1, function ()
    for i, pattern in ipairs(main.getPatternsTable()) do
      main.showPatterns(pattern, {x=640, y=10+100*(i-1)})
    end
    main.wait(5, function ()
      main.hideAllPatterns()
    end)
  end)
end)