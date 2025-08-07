local descriptionList = {}
local activeDescriptions = {}
local maxWidth = {}
local defaultRenderLayer = 400
local spacing = 10

-- later add order
function main.addDescriptionType(func)
  table.insert(descriptionList, func)
end

local function parseDescriptionList(ent)
  local t = {}
  for i, func in ipairs(descriptionList) do
    local text = func(ent)
    -- later seperate \n
    -- local ss, se = string.find(text, "\n")
    -- if ss then
      
    -- end
    if text then
      table.insert(t, text)
    end
  end
  return t
end

local function drawDescription(ent, location, activeDescriptionIndex)
  --CLEAR OUT FIRST BEFORE DRAWING ANOTHER
  if activeDescriptions[activeDescriptionIndex] and #activeDescriptions[activeDescriptionIndex] > 0 then
    return
  end

  local descriptionTable = parseDescriptionList(ent)
  local font = system.getStorage("defaultFont")
  local height = font:getHeight()
  local totalHeight = height * #descriptionTable
  local startX = location.x
  local startY = location.y

  local t = {}
  -- local maxWidth = maxWidth[activeDescriptionIndex] or 0
  for i, format in ipairs(descriptionTable) do
    local text = main.newRichText({format=format,
    x=0,
    y=0,
    outline = true,
    screenSpace = true,
    renderLayer = defaultRenderLayer})
    table.insert(t, text)
    local width = text.richText:getWidth(format)
    maxWidth[activeDescriptionIndex] = math.max(maxWidth[activeDescriptionIndex] or 0, width)
  end
  

  -- set x and y to not get out of screen
  local dimension = system.getStorage("screenDimension")
  local screenW, screenH = dimension.w, dimension.h
  local fixX = math.min(startX+maxWidth[activeDescriptionIndex], screenW)-maxWidth[activeDescriptionIndex]
  local fixY = math.min(startY+totalHeight, screenH)-totalHeight
  for i, richtext in ipairs(t) do
    richtext.x = fixX + spacing
    richtext.y = fixY + (i-1)*(height+spacing)
  end
  
  activeDescriptions[activeDescriptionIndex] = t
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

system.on("ui:UIHovered", function (ui)
  local ent = ui.card or (ui.ui and ui.ui.isNews)
  if ent then
    local mouse = system.getStorage("realMouse")
    drawDescription(ent, mouse, "held")
  else
    removeDescription("held")
  end
end)

system.on("ui:noUIHovered", function ()
  removeDescription("held")
end)

system.on("@mouse:moved", function ()
  local mouse = system.getStorage("realMouse")
  removeDescription("held")
  -- automatically gets added back in UIHovered
end)

-- cool background
system.on("@renderer:render", function ()
  for index, RichTextsList in pairs(activeDescriptions) do
    if #RichTextsList == 0 then
      return
    end
    local startY = RichTextsList[1].y
    local startX = RichTextsList[1].x
    local endX = RichTextsList[#RichTextsList].x
    local endY = RichTextsList[#RichTextsList].y + RichTextsList[#RichTextsList].richText:getHeight()
    local height = endY-startY
    system.render(defaultRenderLayer-1, function ()
      local maxWidth = maxWidth[index] or 0
      love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
      love.graphics.rectangle("fill", startX, startY, maxWidth, height)
      love.graphics.setColor(0.3, 0.3, 0.3, 0.9)
      love.graphics.setLineWidth(10)
      love.graphics.rectangle("line", startX, startY, maxWidth, height)
    end, true)
  end
end)