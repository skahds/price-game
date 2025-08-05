local descriptionList = {}
local RichTextsList = {}
local maxWidth = 0
local defaultRenderLayer = 300

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

local function drawDescription(ent, location)
  --CLEAR OUT FIRST BEFORE DRAWING ANOTHER
  if #RichTextsList > 0 then
    return
  end

  local descriptionTable = parseDescriptionList(ent)
  local font = system.getStorage("defaultFont")
  local height = font:getHeight()
  local totalHeight = height * #descriptionTable
  local spacing = 10
  local startX = location.x
  local startY = location.y

  for i, format in ipairs(descriptionTable) do
    local text = main.newRichText({format=format,
    x=startX + spacing,
    y=startY + (i-1)*(height+spacing),
    outline = true,
    screenSpace = true,
    renderLayer = defaultRenderLayer})
    table.insert(RichTextsList, text)
    local width = font:getWidth(format)
    maxWidth = math.max(maxWidth, width)
  end
  
end

local function noDescription()
  if #RichTextsList == 0 then
    return
  end
  maxWidth = 0
  for _, text in ipairs(RichTextsList) do
    text:delete()
  end
  RichTextsList = {}
end

system.on("ui:UIHovered", function (ui)
  local ent = ui.card or (ui.ui and ui.ui.isNews)
  if ent then
    local mouse = system.getStorage("realMouse")
    drawDescription(ent, mouse)
  else
    noDescription()
  end
end)

system.on("ui:noUIHovered", function ()
  noDescription()
end)

system.on("@renderer:render", function ()
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
  end, true)
end)