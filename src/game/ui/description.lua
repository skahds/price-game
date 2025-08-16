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
function main.addDescriptionType(order, func)
  table.insert(descriptionList, {order=order, func=func})
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
    table.insert(allTags, t)
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

local function setPositionToBeInScreen(location, descriptionTable, maxWidth, maxHeight)
  -- set x and y to not get out of screen
  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  local height = font:getHeight()
  local totalHeight = height * #descriptionTable
  local fixX = math.min(location.x+maxWidth, screenW-spacing)-maxWidth
  local fixY = math.min(location.y+totalHeight, screenH-spacing-maxHeight)-totalHeight
  for i, richtext in ipairs(descriptionTable) do
    richtext.x = fixX
    richtext.y = fixY + (i-1)*(height)
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
  local totalHeight = height * #descriptionTable
  local startX = location.x
  local startY = location.y

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
  

  setPositionToBeInScreen(location, t, maxWidth[activeDescriptionIndex], 0)
  
  activeDescriptions[activeDescriptionIndex] = t
end

local function drawCompleteDescription(ent, location, activeDescriptionIndex)
  removeCompleteDescription(activeDescriptionIndex)

  local descriptionTable = parseDescriptionList(ent)
  drawDescription(descriptionTable, location, activeDescriptionIndex)


  local tags = parseTagsList(ent)
  local currentHeightAdded = 0
  for i, tag in ipairs(tags) do
    -- draw the tags
    local newIndex = getEmptyIndexForTag(activeDescriptionIndex)
    drawDescription(tag, location, newIndex)
    local originalDescription = activeDescriptions[activeDescriptionIndex][1]
    local NewLocation = {x=originalDescription.x - (maxWidth[newIndex]+spacing*2), y=originalDescription.y+currentHeightAdded}

    local newTag = activeDescriptions[newIndex]
    setPositionToBeInScreen(NewLocation, newTag, maxWidth[newIndex], currentHeightAdded)
    currentHeightAdded = currentHeightAdded + font:getHeight() * #newTag + spacing*2
  end
  -- local activeTags = getAllTagsIndexOfDescription(activeDescriptionIndex)
  -- for i, index in ipairs(activeTags) do
  --   local tag = activeDescriptions[index]
  --   setPositionToBeInScreen(NewLocation, tag, maxWidth[newIndex], currentHeightAdded)
  -- end
end

--[[
local function updateDescriptionPos(index, newPosition)
  local RichTextsList = activeDescriptions[index]
  if RichTextsList == nil then
    return
  end
  if #RichTextsList == 0 then
    return
  end

  setPositionToBeInScreen(newPosition, RichTextsList, maxWidth[index])
end

local function updateCompleteDescriptionPos(index, newPos)
  updateDescriptionPos(index, newPos)
  local tagsIndex = getAllTagsIndexOfDescription(index)
  for i, tagIndex in ipairs(tagsIndex) do
    local NewLocation = {x=newPos.x - (maxWidth[index]+spacing*2), y=newPos.y+((i-1)*100)}
    updateDescriptionPos(tagIndex, NewLocation)
  end
end
]]

system.on("ui:UIHovered", function (ui)
  local ent
  if ui.parent then
    ent = ui.parent
  elseif ui.parent and ui.parent.isNews then
    ent = ui.parent
  end

  if ent then
    local mouse = system.getStorage("realMouse")
    drawCompleteDescription(ent, mouse, "held")
  else
    removeCompleteDescription("held")
  end
end)

system.on("ui:noUIHovered", function ()
  removeCompleteDescription("held")
end)

-- system.on("@mouse:moved", function ()
--   local mouse = system.getStorage("realMouse")
--   -- since it constantly moves, we don't use updateDescriptionPos
--   -- removeCompleteDescription("held")
--   updateCompleteDescriptionPos("held", mouse)
--   -- automatically gets added back in UIHovered
-- end)

-- cool background
system.on("@renderer:render", function ()
  for index, RichTextsList in pairs(activeDescriptions) do
    if #RichTextsList > 0 then
      local startY = RichTextsList[1].y - spacing
      local startX = RichTextsList[1].x - spacing
      local endY = RichTextsList[#RichTextsList].y + RichTextsList[#RichTextsList].richText:getHeight()
      local height = endY-startY + spacing
      system.render(defaultRenderLayer-1, function ()
        local maxWidth = (maxWidth[index] or 0) + spacing*2
        love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
        love.graphics.rectangle("fill", startX, startY, maxWidth, height, spacing, spacing)
        love.graphics.setColor(0.3, 0.3, 0.3, 0.9)
        love.graphics.setLineWidth(spacing/2)
        love.graphics.rectangle("line", startX, startY, maxWidth, height, spacing, spacing)
      end, true)
    end
  end
end)