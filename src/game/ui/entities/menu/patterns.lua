local renderLayer = 220
local flux = system.getStorage("flux")
local listOfPositive = {}
local listOfNegative = {}
local existingItems = {}
local close
local cover
local topText
local hovering = nil

local greenColor, redColor = {0.2, 0.8, 0.2}, {0.8, 0.2, 0.2}

system.on("@load", function ()
  local listOfItems = utils.deepCopy(main.getPatternsTable())
  for i, item in ipairs(listOfItems) do
    if item.price * item.mult > 0 then
      table.insert(listOfPositive, item)
    else
      table.insert(listOfNegative, item)
    end
  end
end)

system.on("@update", function ()
  if hovering == nil then
    for k, item in ipairs(existingItems) do
      if item.pattern then
        item.isVisible = true
        item.overrideHitbox.x = item.x
        item.overrideHitbox.y = item.y
        item.overrideHitbox.ox = item.ox
        item.overrideHitbox.oy = item.oy
      end
    end

    return
  end
  local pattern
  for i, v in ipairs(main.getPatternsTable()) do
    if v.id == hovering then
      pattern = v
    end
  end

  -- set isVisible of items to clear up space
  if pattern.price * pattern.mult > 0 then
    for k, item in ipairs(existingItems) do
      if item.pattern then
        if item.x > 640 then
          item.isVisible = false
        else
          item.isVisible = true
        end
      end
    end
  else
    for k, item in ipairs(existingItems) do
      if item.pattern then
        if item.x > 640 then
          item.isVisible = true
        else
          item.isVisible = false
        end
      end
    end
  end

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
    local h = height*-direction*50
    table.insert(sequence, height*-direction*50)
    currentY = currentY + h
    highY = math.min(highY, currentY)
    lowY = math.max(lowY, currentY)
  end
  local totalHeight = lowY-highY

  system.render(renderLayer+1, function ()
    local amountOfBar = #pattern.sequence
    local startX
    if pattern.price*pattern.mult > 0 then
      startX = 640+200
    else
      startX = 640-200
    end
    
    local currentY = 0
    for i, bar in ipairs(sequence) do
      if bar > 0 then
        love.graphics.setColor(redColor)
      else
        love.graphics.setColor(greenColor)
      end

      local xoffset = (-amountOfBar/2-0.5+i)*60
      local yoffset = highY+totalHeight/2
      love.graphics.rectangle("fill", startX-25+xoffset, 360+currentY-yoffset, 50, bar)
      currentY = currentY + bar
    end
  end, true)
end)

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local function clearExistingItem()
  for i=#existingItems, 1, -1 do
    local item = existingItems[i]
    if item.delete then
      item:delete()
    end
  end
  
  existingItems = {}
end

local stacks = {listOfPositive, listOfNegative}
local function updateContent()
  clearExistingItem()
  
  for k, stack in ipairs(stacks) do
    for i, pattern in ipairs(stack) do
      local x
      if k == 1 then
        x = 640-200
      else
        x = 640+200
      end
      local y = 160+(i-1)*100

      local t = main.ui.spawnUI("patternsPlate", {
        x=x,
        y=y,
        ox=180,
        pattern = pattern.id,
        text = pattern.name .. " {priceColor}{priceIcon}" .. pattern.price .. "{/priceColor} {multColor}{multIcon}" .. pattern.mult,
        renderLayer = renderLayer+1,
        font = system.getFont("defaultFont40")
      })

      table.insert(existingItems, t)
    end
  end

  -- for i=1, contentInThisPage do
  --   local itemI = startI+i --yeahyeah it starts at 0 whatever
  --   local item = listOfItems[itemI].definition
  --   local middleX = 640
  --   local x = (i-1)%contentHorizontal
  --   local y = math.floor((i-1)/contentHorizontal)
  --   if item.isCard then
  --     local c = main.createCard(item.id, {ignoreCardSelect=true}, "misc")
  --     c.ui.renderLayer = renderLayer+2
  --     c.ui.x=middleX
  --     flux.to(c.ui, 0.2, {x=640+(x-1.5)*800/contentHorizontal}):ease("backout")
  --     c.ui.y=340+(y-1)*130
  --     c.ui.ox = c.ui.width/2
  --     c.ui.oy = c.ui.height/2
  --     table.insert(existingItems, c)
  --   elseif item.isNews then
  --     local n = main.spawnEntity(item.id, {x=middleX, y=340+(y-1)*130})
  --     flux.to(n.ui, 0.2, {x=640+(x-1.5)*800/contentHorizontal}):ease("backout")
  --     n.isRelic = true
  --     n.ui.renderLayer = renderLayer+2
  --     n.ui.sx = 2
  --     n.ui.sy = 2
  --     n.ui.ox = n.ui.width/2
  --     n.ui.oy = n.ui.height/2
  --     n.rewardIndex = i
  --     n.ui.screenSpace = true
  --     n.screenSpace = true
  --     table.insert(existingItems, n)
  --   end
  -- end
end

local function buttonClick(n)

end

main.defineUITab("patterns", function ()
  cover = main.ui.spawnUI("cover", {
    x=640-400,
    y=360-300,
    width = 800,
    height = 600,
    color = {0.6, 0.6, 0.6},
    outline = 10,
    rx=20,
    ry=20,
    outlineColor = {0.4, 0.4, 0.4},
    ignoreUIChecks = false,
    renderLayer = renderLayer})

  topText = main.newRichText({
    x=640,
    y=80,
    format = "Patterns",
    renderLayer = renderLayer+1,
    font = system.getFont("defaultFont80")
  })
  topText.x = topText.x - topText.richText:getWidth()/2

  close = main.ui.spawnUI("patternsClose", {
    x=940,
    y=80,
    renderLayer = renderLayer+2,
  })

  updateContent()
end, function ()

  clearExistingItem()
  deleteAll({cover, close, topText})
end)

main.ui.defineButton("openPatterns", {
  width = 250,
  height = 100,
  color = {0.43, 0.32, 0.7},
  renderLayer = 101,
  screenSpace = true,
  text = "PATTERNS",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.openUITab("patterns")
  end
})

main.ui.defineButton("patternsClose", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "X",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.openUITab("patterns", false)
  end
})

local normalColor = {0.6, 0.6, 0.6}
local hoverColor = {0.7, 0.7, 0.7}
main.ui.defineUI("patternsPlate", {
  width=360,
  height=80,
  overrideHitbox = {width=360, height=102, x=0, y=0},
  color = normalColor,
  outline=10,
  outlineColor = {0.4, 0.4, 0.4},
  rx=20,
  ry=20,
  onHover = function (ent)
    ent.color = hoverColor
    hovering = ent.pattern
  end,

  notHovered = function (ent)
    ent.color = normalColor
    if hovering == ent.pattern then
      hovering = nil
    end
  end
})