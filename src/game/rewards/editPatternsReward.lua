local flux = system.getStorage("flux")
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

function main.createRewardsEditPattern()

  table.insert(existingUI, main.ui.spawnUI("rerollEditPattern", {
    x=640-400-125,
    y=y-50,
  }))

  setRandomPattern()
end

function main.clearRewardEditPattern()
  for i, ui in ipairs(existingUI) do
    ui:delete()
  end
end

system.on("@update", function ()
  if patternSelected == nil then
    return
  end

  local t = main.printRichText({
    format = "{moneyColor}$" .. main.getMoney(),
      x=640-400,
      y=y+100,
      renderLayer = 140,
      font = system.getFont("defaultFont80"),
      outline = true
    })
  t.x = t.x - t.richText:getWidth()/2

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
    x=startX,
    y=40,
    outline=true
  })
  t.x = t.x - t.richText:getWidth()/2
  local t = main.printRichText({
    format = "{priceColor}" .. format(pattern.price) .. "{priceIcon}{/priceColor} {multColor}" .. format(pattern.mult) .. "{multIcon}",
    renderLayer = renderLayer+1,
    x=startX,
    y=40,
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
      x=startX+400,
      y=360,
      outline=true,
    })
    t.x = t.x - t.richText:getWidth()/2
    t.y = t.y - t.richText:getHeight()*(#pattern.sequence-i+1) - t.richText:getHeight()/2
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
      love.graphics.rectangle("fill", startX-25+xoffset, 300+currentY-yoffset, 50, bar)
      currentY = currentY + bar
    end
  end, true)
end)

local function reroll()
  setRandomPattern()
end

main.ui.defineButton("rerollEditPattern", {
  width = 250,
  height = 100,
  color = {0.4, 0.7, 0.4},
  renderLayer = 130,
  screenSpace = true,
  cost = 2,
  text = "Reroll {moneyColor}$2{/moneyColor}",
  audio = "breaker",
  onButtonClicked = function (ent)
    if patternSelected == nil then return end
    if main.getMoney() > ent.cost then
      main.addMoney(-ent.cost)
    else
      return
    end

    ent.cost = ent.cost + 1
    main.updateRichTextText(ent.richtext, "Reroll {moneyColor}$" .. ent.cost .. "{/moneyColor}")
    reroll()
  end
})