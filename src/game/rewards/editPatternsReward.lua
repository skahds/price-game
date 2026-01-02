local flux = system.getStorage("flux")
local pipeline = main.getPipeline("main")
local existingUI = {}
local y = 640*2/5
local patternSelected
local barOptions = {}

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

local function capitalize(str)
  return (str:gsub("^%l", string.upper))
end

function main.createRewardsEditPattern()
  for i=1, 3 do
    local size = "any"
    local num = love.math.random()
    if num < 1/3 then
      size = "smaller"
    elseif num < 2/3 then
      size = "bigger"
    end
    local direction = "positive"
    if love.math.random() > 0.5 then
      direction = "negative"
    end
    local capitalizedString = capitalize(size) .. capitalize(direction)
    local c = main.createCard("editPatternCard", {}, "patterns")
    c.name = capitalize(size) .. " " .. direction
    c.patternValue = size .. direction
    c.ignoreCardSelect = true
    c.ui.image="patterns" .. capitalizedString
    c.ui.x = 640+400
    c.ui.y = 360+(i-2)*150-c.ui:getWidth()/2
  end

  setRandomPattern()
end

function main.clearRewardEditPattern()
  for i, ui in ipairs(existingUI) do
    ui:delete()
  end

  for i=#main.card.patterns, 1, -1 do
    pipeline:add(0.15, function ()
      local card = main.card.patterns[i]
      main.deleteCard(card)
    end)
  end
end

system.on("main:cardClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.ownerShip == "patterns" then
    table.insert(patternSelected.sequence, ent.patternValue)
  else
    return
  end

  main.clearRewardEditPattern()
end)

system.on("@update", function ()
  if patternSelected == nil then
    return
  end

  local pattern = patternSelected

  local startX = 640

  local highY = 0
  local lowY = 0
  local currentY = 0
  local sequence = {}
  for i, bar in ipairs(pattern.sequence) do
    local height
    if string.match(bar, "any") then
      height = 1
    elseif string.match(bar, "smaller") then
      height = 0.5
    else
      height = 1.5
    end
    local direction
    if string.match(bar, "positive") then
      direction = 1
      love.graphics.setColor(greenColor)
    else
      direction = -1
    end
    local h = height*-direction*60
    table.insert(sequence, h)
    currentY = currentY + h
    highY = math.min(highY, currentY)
    lowY = math.max(lowY, currentY)
  end
  local totalHeight = lowY-highY

  local t = main.printRichText({
    format = pattern.name,
    renderLayer = renderLayer+1,
    x=startX-400,
    y=100,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2
  local t = main.printRichText({
    format = "{priceColor}" .. format(pattern.price) .. "{priceIcon}{/priceColor} {multColor}" .. format(pattern.mult) .. "{multIcon}",
    renderLayer = renderLayer+1,
    x=startX-400,
    y=100,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y + t.richText:getHeight()

  for i, bar in ipairs(pattern.sequence) do
    local text = ""
    local color
    if string.match(bar, "any") then
      text = text .. "Any"
    elseif string.match(bar, "smaller") then
      text = text .. "Smaller"
    else
      text = text .. "Bigger"
    end
    text = text .. " "
    if string.match(bar, "negative") then
      text = text .. "negative"
      color = redColor
    else
      text = text .. "positive"
      color = greenColor
    end
    local t = main.printRichText({
      format = text,
      renderLayer = renderLayer+1,
      color = color,
      x=startX-400,
      y=460,
      outline=true,
    })
    t.x = t.x - t.richText:getWidth()/2
    t.y = t.y + t.richText:getHeight()*(i-1)
  end

  system.render(renderLayer+1, function ()
    local amountOfBar = #pattern.sequence
    
    local currentY = 0
    for i, bar in ipairs(sequence) do
      if bar > 0 then
        love.graphics.setColor(redColor)
      else
        love.graphics.setColor(greenColor)
      end

      local xoffset = (-amountOfBar/2-0.5+i)*60
      local yoffset = highY+totalHeight/2
      love.graphics.rectangle("fill", startX-25+xoffset-400, 360+currentY-yoffset, 50, bar)
      currentY = currentY + bar
    end
  end, true)
end)