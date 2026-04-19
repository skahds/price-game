local renderLayer = 220
local flux = system.getStorage("flux")
local existingItems = {}
local close
local cover
local topText
local hovering = nil
local clickSelected = nil
local patternsUI

local function format(n)
  if n > 0 then
    return "+" .. n
  else
    return n
  end
end

local function deleteAll(args)
  if args == nil then return end
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
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

local function updateContent()
  clearExistingItem()

  local listOfPositive = {}
  local listOfNegative = {}

  local listOfItems = main.getPatternsTable()
  for i, item in ipairs(listOfItems) do
    if item.defaultPrice > 0 then
      table.insert(listOfPositive, item)
    else
      table.insert(listOfNegative, item)
    end
  end
  local stacks = {listOfPositive, listOfNegative}
  
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
        text = pattern.name .. " {priceColor}" .. format(pattern.price) .. "{priceIcon}{/priceColor} {multColor}" .. format(pattern.mult) .. "{multIcon}",
        textOutline=true,
        textOutlineColor={0,0,0},
        renderLayer = renderLayer+1,
        font = system.getFont("defaultFont40")
      })

      table.insert(existingItems, t)
    end
  end
end

system.on("@update", function ()
  if patternsUI then
    main.hidePatterns(patternsUI)
  end

  if hovering == nil and clickSelected == nil then
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
    if v.id == (clickSelected or hovering) then
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

  local startX
  if pattern.price*pattern.mult > 0 then
    startX = 640+200
  else
    startX = 640-200
  end

  local t = main.printRichText({
    format = pattern.name,
    renderLayer = renderLayer+1,
    x=startX,
    y=160,
    outline=true,
    outlineColor={0,0,0},
  })
  t.x = t.x - t.richText:getWidth()/2
  local t = main.printRichText({
    format = "{priceColor}" .. format(pattern.price) .. "{priceIcon}{/priceColor} {multColor}" .. format(pattern.mult) .. "{multIcon}",
    renderLayer = renderLayer+1,
    x=startX,
    y=160,
    outline=true,
    outlineColor={0,0,0},
  })
  t.x = t.x - t.richText:getWidth()/2
  t.y = t.y + t.richText:getHeight()

  main.resultOfPattern(pattern)
  patternsUI = main.showPatterns(pattern, {x=startX, y=360, renderLayer=300})
end)

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
    font = system.getFont("defaultFont80"),
    outline=true,
    outlineColor={0,0,0},
  })
  topText.x = topText.x - topText.richText:getWidth()/2

  close = main.ui.spawnUI("patternsClose", {
    x=940,
    y=80,
    renderLayer = renderLayer+2,
  })

  updateContent()
end, function ()
  hovering = nil
  clickSelected = nil

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

-- local normalColor = {0.6, 0.6, 0.6}
-- local hoverColor = {0.7, 0.7, 0.7}
-- local selectedColor = {0.8, 0.8, 0.8}
local normalColor = {0.7, 0.7, 0.7}
local hoverColor = {0.8, 0.8, 0.8}
local selectedColor = {0.9, 0.9, 0.9}
main.ui.defineUI("patternsPlate", {
  width=360,
  height=80,
  overrideHitbox = {width=360, height=102, x=0, y=0},
  color = normalColor,
  outline=10,
  outlineColor = {0.5, 0.5, 0.5},
  rx=20,
  ry=20,
  onHover = function (ent)
    if clickSelected ~= ent.pattern then
      ent.color = hoverColor
    elseif clickSelected == ent.pattern then
      ent.color = selectedColor
    end
    
    hovering = ent.pattern
  end,

  onMouseClicked = function (ent)
    if clickSelected == ent.pattern then
      clickSelected = nil
    else
      clickSelected = ent.pattern
    end
  end,

  notHovered = function (ent)
    if clickSelected == ent.pattern then
      ent.color = selectedColor
    else
      ent.color = normalColor
    end

    if hovering == ent.pattern then
      hovering = nil
    end
  end
})