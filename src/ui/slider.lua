-- todo: fix
local function updateRXRY(sliderObject)
  local width = sliderObject.width or sliderObject.defaultWidth
  local height = sliderObject.height or sliderObject.defaultHeight
  local a = width/2
  local b = height/2
  local r = math.min(a, b)
  sliderObject.rx = r
  sliderObject.ry = r
end

local function sliderUpdate(sliderObject)
  updateRXRY(sliderObject)
  local slideDirection = sliderObject.slideDirection or "horizontal"
  if love.mouse.isDown(sliderObject.button or 1) then
    local mouse

    if sliderObject.screenSpace == false then
      mouse = system.getStorage("mouse")
    else
      mouse = system.getStorage("realMouse")
    end

    -- onSlide gets itself and slide amount in percentage
    if main.AABB_check(sliderObject, mouse) then
      local amountScrolled
      if slideDirection == "horizontal" then
        amountScrolled = (mouse.x - sliderObject.x) / (sliderObject:getWidth())
      elseif slideDirection == "vertical" then
        amountScrolled = (mouse.y - sliderObject.y) / (sliderObject:getHeight())
      end
      -- makes sure it cant go outside of 0-1
      amountScrolled = math.max(0, math.min(1, amountScrolled))
      if sliderObject.onSlide then
        sliderObject.onSlide(sliderObject, amountScrolled)
      end
    end
  end
end

-- tertiery UI, this is the "end product"
function main.ui.defineSlider(id, eType)
  eType.update = sliderUpdate
  main.ui.defineUI(id, eType)
end