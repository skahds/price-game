--diff between top and bottom is 20% of height
local flux = system.getStorage("flux")

local function basicSetter(ent)
  if ent.buttonYOffset == nil then
    ent.buttonYOffset = 0
  end

  if ent.buttonDownColor == nil then
    local color = ent.color or {1, 1, 1, 1}
    local c = 2/3
    ent.buttonDownColor = {color[1]*c, color[2]*c, color[3]*c, color[4] or 1}
  end
end

local function buttonUp(ent)
  basicSetter(ent)

  if ent.isButtonDown == false then
    return
  end
  if ent.tween then
    ent.tween:stop()
  end
  ent.tween = flux.to(ent, 0.1, {buttonYOffset=0})

  ent.isButtonDown = false
end

local function buttonDown(ent)
  basicSetter(ent)

  if ent.isButtonDown == true then
    return
  end
  if ent.tween then
    ent.tween:stop()
  end
  ent.tween = flux.to(ent, 0.1, {buttonYOffset=ent.height/6})

  ent.isButtonDown = true
end

function main.ui.defineButton(id, eType)
  eType.isButtonDown = false
  eType.drawDefaultRectangle = false


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

  function eType.onMouseReleased(ent, button)
    buttonUp(ent)

    if ent.audio then
      local audio = system.playAudio(ent.audio)
    end
    
    if ent.onButtonClicked then
      ent:onButtonClicked(button)
    end
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

    local rl = ent.renderLayer
    system.render(rl-1, function ()
      love.graphics.setColor(ent.buttonDownColor)
      love.graphics.rectangle("fill", ent.x, ent.y+ent.height/6, ent.width, ent.height, ent.rx, ent.ry)
      love.graphics.setColor(ent.color)
      love.graphics.rectangle("fill", ent.x, ent.y+ent.buttonYOffset, ent.width, ent.height, ent.rx, ent.ry)
    end, ent.screenSpace)

    system.render(rl, function ()
      love.graphics.setColor(ent.color[1]*0.95, ent.color[2]*0.95, ent.color[3]*0.95)
      love.graphics.setLineWidth(10)
      love.graphics.rectangle("line", ent.x+4, ent.y+ent.buttonYOffset+4, ent.width-8, ent.height-8, ent.rx, ent.ry)
    end, ent.screenSpace)
  end

  eType.image = eType.image or eType.onButtonUpImage

  main.ui.defineUI(id, eType)
end