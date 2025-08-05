local descriptionList = {}
local activeDescriptions = {}
local maxWidth = 0
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
  for i, format in ipairs(descriptionTable) do
    local text = main.newRichText({format=format,
    x=startX + spacing,
    y=startY + (i-1)*(height+spacing),
    outline = true,
    screenSpace = true,
    renderLayer = defaultRenderLayer})
    table.insert(t, text)
    local width = text.richText:getWidth(format)
    maxWidth = math.max(maxWidth, width)
  end
  
  activeDescriptions[activeDescriptionIndex] = t
end

-- local function updateDescription(currentDescription, location)
--   local mouse = system.getStorage("realMouse")
--   local startX = location.x
--   local startY = location.y
--   for i, text in ipairs(currentDescription) do
--     local height = text.richText:getHeight()
--     text.x = location.x
--     text.y=startY + (i-1)*(height+spacing)
--   end
-- end

local function removeDescription(index)
  local RichTextsList = activeDescriptions[index]
  if RichTextsList == nil then
    return
  end
  if #RichTextsList == 0 then
    return
  end
  maxWidth = 0
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
  for k, RichTextsList in pairs(activeDescriptions) do
    if #RichTextsList == 0 then
      return
    end
    local startY = RichTextsList[1].y
    local startX = RichTextsList[1].x
    local endX = RichTextsList[#RichTextsList].x
    local endY = RichTextsList[#RichTextsList].y + RichTextsList[#RichTextsList].richText:getHeight()
    local width= endX-startX
    local height = endY-startY
    system.render(defaultRenderLayer-1, function ()
      love.graphics.setColor(0.5, 0.5, 0.5, 0.8)
      love.graphics.rectangle("fill", startX, startY, maxWidth, height)
      love.graphics.setColor(0.3, 0.3, 0.3, 0.9)
      love.graphics.setLineWidth(10)
      love.graphics.rectangle("line", startX, startY, maxWidth, height)
    end, true)
  end
end)