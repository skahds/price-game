local patterns = {
  -- {id="crows", name="Crows", sequence={"positive", "smallernegative", "smallerpositive", mult=10, price=20}}
}

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

function main.definePattern(t)
  table.insert(patterns, t)
  table.sort(patterns, function (a, b)
    return math.abs(a.mult*a.price) > math.abs(b.mult*b.price)
  end)
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

function main.resetPatterns()
  patterns = {}
  --positive
  main.definePattern({id="star", name="Star", sequence={"anynegative", "smallernegative", "positive"}, mult=4, price=20})
  main.definePattern({id="soliders", name="Soliders", sequence={"anypositive", "anypositive", "anypositive"}, mult=3, price=12})
  main.definePattern({id="upReversal", name="Up Reversal", sequence={"anynegative", "smallerpositive"}, mult=2, price=8})
  main.definePattern({id="upEngulf", name="Up Engulf", sequence={"anynegative", "positive"}, mult=2, price=6})
  main.definePattern({id="upCandle", name="Up Candle", sequence={"anypositive"}, mult=1, price=2})


  --negative
  main.definePattern({id="moon", name="Moon", sequence={"anypositive", "smallerpositive", "negative"}, mult=4, price=-20})
  main.definePattern({id="crows", name="Crows", sequence={"anynegative", "anynegative", "anynegative"}, mult=3, price=-12})
  main.definePattern({id="downReversal", name="Down Reversal", sequence={"anypositive", "smallernegative"}, mult=2, price=-8})
  main.definePattern({id="downEngulf", name="Down Engulf", sequence={"anypositive", "negative"}, mult=2, price=-6})
  main.definePattern({id="downCandle", name="Down Candle", sequence={"anynegative"}, mult=1, price=-2})
end
main.resetPatterns()

system.register("patterns", 18, function ()
  return patterns
end, function (t)
  patterns = t
end)