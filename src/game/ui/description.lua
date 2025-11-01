local descriptionList = {}
local tagList = {}
local activeDescriptions = {}
local maxWidth = {}
local defaultRenderLayer = 400
local spacing = 10
local font = system.getFont("defaultFont30")

--[[
ORDER LISTS:
MISC - 50
IMPORTANT-er MISC - 60
]]
function main.addDescriptionType(order, func, isLine)
  table.insert(descriptionList, {order=order, func=func, isLine = isLine})
  table.sort(descriptionList, function (a, b)
    return a.order < b.order
  end)
end

function main.addDescriptionTag(order, func)
  table.insert(tagList, {order=order, func=func})
  table.sort(descriptionList, function (a, b)
    return a.order < b.order
  end)
end

local function parseDescriptionList(ent)
  local t = {}
  for i, descriptionType in ipairs(descriptionList) do
    local text = descriptionType.func(ent)

    if text then

    while true do
      local ss, se = string.find(text, "\n")
      if ss then
        local firstPart = string.sub(text, 1, ss)
        table.insert(t, firstPart)
        text = string.sub(text, se+1, #text)
      else
        break
      end
    end
    
      table.insert(t, text)
    end
  end
  return t
end

local function parseTagsList(ent)
  local allTags = {}
  for i, descriptionType in ipairs(tagList) do
    local t = {}
    local text = descriptionType.func(ent)
    if text then
      while true do
        local ss, se = string.find(text, "\n")
        if ss then
          local firstPart = string.sub(text, 1, ss)
          table.insert(t, firstPart)
          text = string.sub(text, se+1, #text)
        else
          break
        end
      end

      table.insert(t, text)
    end
    if #t > 0 then
      table.insert(allTags, t)
    end
  end

  -- returns something like {{"BLUE"}, {"YEAH", "COOL"}}
  return allTags
end

local function getEmptyIndexForTag(index)
  local i = 1
  while true do
    local emptyIndex = index .. i
    if activeDescriptions[emptyIndex] == nil or
    #activeDescriptions[emptyIndex] == 0 then
      return emptyIndex
    end
    i = i + 1
  end
end

local function getAllTagsIndexOfDescription(index)
  local t = {}
  local i = 1
  while true do
    local tag = activeDescriptions[index .. i]
    if tag and #tag > 0 then
      table.insert(t, index .. i)
      i = i + 1
    else
      break
    end
  end
  return t
end

local function setPositionToBeInScreen(location, descriptionTable, maxWidth, extraInfo)
  extraInfo = extraInfo or {totalHeightAdded=0, currentHeight=0}
  -- set x and y to not get out of screen
  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  local height = font:getHeight()
  local totalHeight = height * #descriptionTable
  local gap = extraInfo.totalHeightAdded-extraInfo.currentHeight
  if gap ~= 0 then
    gap = gap - totalHeight
  end
  local fixX = math.min(location.x+maxWidth, screenW-spacing*2)-maxWidth
  local fixY = math.min(location.y+totalHeight, screenH-spacing*2-gap)-totalHeight
  for i, richtext in ipairs(descriptionTable) do
    richtext.x = fixX
    richtext.y = fixY + (i-1)*(height)
  end

  -- center text
  for i, richtext in ipairs(descriptionTable) do
    local width = richtext.richText:getWidth()
    local extra = (maxWidth-width)/2
    richtext.x = richtext.x + extra
  end
end

local function removeDescription(index)
  local RichTextsList = activeDescriptions[index]
  if RichTextsList == nil then
    return
  end
  if #RichTextsList == 0 then
    return
  end
  maxWidth[index] = 0
  for _, text in ipairs(RichTextsList) do
    text:delete()
  end
  activeDescriptions[index] = {}
end

local function removeCompleteDescription(index)
  removeDescription(index)
  local tagsIndex = getAllTagsIndexOfDescription(index)
  for i, tagIndex in ipairs(tagsIndex) do
    removeDescription(tagIndex)
  end
end

local function drawDescription(descriptionTable, location, activeDescriptionIndex)
  --CLEAR OUT FIRST BEFORE DRAWING ANOTHER
  if activeDescriptions[activeDescriptionIndex] and #activeDescriptions[activeDescriptionIndex] > 0 then
    return
  end

  local height = font:getHeight()

  local t = {}
  for i, format in ipairs(descriptionTable) do
    local text = main.newRichText({format=format,
    x=0,
    y=0,
    -- outline = true,
    screenSpace = true,
    renderLayer = defaultRenderLayer,
    font = font})
    table.insert(t, text)
    local width = text.richText:getWidth(format)
    maxWidth[activeDescriptionIndex] = math.max(maxWidth[activeDescriptionIndex] or 0, width)
  end

  setPositionToBeInScreen(location, t, maxWidth[activeDescriptionIndex])
  
  activeDescriptions[activeDescriptionIndex] = t
end

local function drawCompleteDescription(ent, location, activeDescriptionIndex)
  removeCompleteDescription(activeDescriptionIndex)

  local descriptionTable = parseDescriptionList(ent)
  drawDescription(descriptionTable, location, activeDescriptionIndex)

  local originalXPosition = math.huge
  for i, text in ipairs(activeDescriptions[activeDescriptionIndex]) do
    originalXPosition = math.min(originalXPosition, text.x)
  end

  -- spawn tag
  local tags = parseTagsList(ent)
  local totalHeightAdded = 0
  for i, tag in ipairs(tags) do
    -- draw the tags
    local newIndex = getEmptyIndexForTag(activeDescriptionIndex)
    drawDescription(tag, location, newIndex)

    local newTag = activeDescriptions[newIndex]
    totalHeightAdded = totalHeightAdded + font:getHeight() * #newTag + spacing
  end
  totalHeightAdded = totalHeightAdded + spacing

  -- set position
  local currentHeightAdded = 0
  local activeTags = getAllTagsIndexOfDescription(activeDescriptionIndex)
  for i, index in ipairs(activeTags) do
    local tag = activeDescriptions[index]
    local originalDescription = activeDescriptions[activeDescriptionIndex][1]
    local NewLocation = {x=originalXPosition - (maxWidth[index]+spacing*2), y=originalDescription.y+currentHeightAdded}
    setPositionToBeInScreen(NewLocation, tag, maxWidth[index],
    {totalHeightAdded=totalHeightAdded, currentHeight=currentHeightAdded})
    currentHeightAdded = currentHeightAdded + font:getHeight() * #tag + spacing*2
  end
end

local currentHeldCard
system.on("@update", function ()
  currentHeldCard = system.getStorage("main:currentSelectedCard")
  
  if currentHeldCard then
    local screenDimension = system.getStorage("screenDimension")
    local pos = {x=screenDimension.w*3/4+80, y=270}
    drawCompleteDescription(currentHeldCard, pos, "selected")
  else
    removeCompleteDescription("selected")
  end

  for i=1, #main.world+2 do
    removeCompleteDescription("A" .. i .. "A")
  end
  for i=1, #main.ui.world+2 do
    removeCompleteDescription("B" .. i .. "B")
  end

  for i, entity in ipairs(main.world) do
    if entity.showingDescription then
      local pos
      if entity.ui then
        pos = {x=entity.ui.x, y=entity.ui.y+entity.ui.height+20}
      else
        pos = {x=entity.ui.x, y=entity.ui.y+entity.ui.height+20}
      end
      drawCompleteDescription(entity, pos, "A" .. entity.index .. "A")
    end
  end

  for i, entity in ipairs(main.ui.world) do
    if entity.showingDescription then
      drawCompleteDescription(entity, {x=entity.x, y=entity.y+entity.height+20}, "B" .. entity.index .. "B")
    end
  end
end)

system.on("ui:UIHovered", function (ui)
  if currentHeldCard then
    removeCompleteDescription("held")
    return
  end

  local ent
  if ui.parent then
    ent = ui.parent
  elseif ui.showDescription then
    ent= ui
  end

  if ent then
    local mouse = system.getStorage("realMouse")
    local newPos = {x=mouse.x+spacing, y=mouse.y+spacing}
    drawCompleteDescription(ent, newPos, "held")
  else
    removeCompleteDescription("held")
  end
end)

system.on("ui:noUIHovered", function ()
  removeCompleteDescription("held")
end)

-- cool background
system.on("@draw", function ()
  for index, RichTextsList in pairs(activeDescriptions) do
    if #RichTextsList > 0 then
      local startY = RichTextsList[1].y - spacing
      local centerGap = ((maxWidth[index] or 0)-RichTextsList[1].richText:getWidth())/2
      local startX = RichTextsList[1].x - spacing - centerGap
      local endY = RichTextsList[#RichTextsList].y + RichTextsList[#RichTextsList].richText:getHeight()
      local height = endY-startY + spacing
      local width = (maxWidth[index] or 0) + spacing*2
      system.render(defaultRenderLayer-1, function ()
        love.graphics.setColor(0, 0, 0, 0.6)
        love.graphics.rectangle("fill", startX, startY, width, height, spacing, spacing)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.setLineWidth(spacing/4)
        love.graphics.rectangle("line", startX, startY, width, height, spacing, spacing)

        love.graphics.setColor(0.6, 0.6, 0.6, 0.6)
        local y = RichTextsList[1].y + RichTextsList[1].richText:getHeight()
        love.graphics.line(RichTextsList[1].x-centerGap, y, RichTextsList[1].x+centerGap+RichTextsList[1].richText:getWidth(), y)
      end, true)
    end
  end
end)