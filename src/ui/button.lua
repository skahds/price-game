--diff between top and bottom is 20% of height
local flux = system.getStorage("flux")

local function basicSetter(ent)
  if ent.originalY == nil then
    ent.originalY = ent.y
  end

  if ent.buttonDownColor == nil then
    local color = ent.color or {1, 1, 1, 1}
    ent.buttonDownColor = {color[1]/2, color[2]/2, color[3]/2, color[4] or 1}
  end
end

local function richTextUpdate(ent)
  if ent.richtext == nil then
    return
  end
  local font = system.getStorage("defaultFont")
  local textWidth = font:getWidth(ent.richtext.format)
  local textHeight = font:getHeight(ent.richtext.format)
  ent.richtext.x = ent.x+ent.width/2-textWidth/2
  ent.richtext.y = ent.y+ent.height/2-textHeight/2
end

local function buttonUp(ent)
  basicSetter(ent)

  if ent.isButtonDown == false then
    return
  end
  ent.tween = flux.to(ent, 0.1, {y=ent.originalY})

  ent.isButtonDown = false
end

local function buttonDown(ent)
  basicSetter(ent)

  if ent.isButtonDown == true then
    return
  end
  ent.tween = flux.to(ent, 0.1, {y=ent.originalY+ent.height/5})

  ent.isButtonDown = true
end

function main.ui.defineButton(id, eType)
  eType.isButtonDown = false
  if eType.text then
    eType.richtext = main.newRichText({format=eType.text,
    x=eType.x,
    y=eType.y,
    screenSpace = eType.screenSpace,
    renderLayer = eType.renderLayer+1})
  end

  if eType.width > eType.height then
    local a = eType.width / ((eType.width/eType.height) * 4)
    local b = eType.height / ((eType.width/eType.height) * 2)
    local r = math.min(a, b)
    eType.rx = r
    eType.ry = r
  else
    local a = eType.width / ((eType.height/eType.width) * 2)
    local b = eType.height / ((eType.height/eType.width) * 4)
    local r = math.min(a, b)
    eType.rx = r
    eType.ry = r
  end

  function eType.onMouseReleased(ent)
    if ent.onButtonClicked then
      ent:onButtonClicked()
    end

    buttonUp(ent)
  end

  function eType.onHover(ent)
    if love.mouse.isDown(1) then
      buttonDown(ent)
    end
  end

  function eType.notHovered(ent)
    buttonUp(ent)
  end

  function eType.onDraw(ent)
    basicSetter(ent)
    richTextUpdate(ent)

    local rl = ent.renderLayer
    system.render(rl-1, function ()
      love.graphics.setColor(ent.buttonDownColor)
      love.graphics.rectangle("fill", ent.x, ent.originalY+ent.height/5, ent.width, ent.height, ent.rx, ent.ry)
    end, ent.screenSpace)
  end

  eType.image = eType.image or eType.onButtonUpImage

  main.ui.defineUI(id, eType)
end