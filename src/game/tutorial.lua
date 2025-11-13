local flux = system.getStorage("flux")

local targettedEnt = {
  --{originalRenderLayer = 10, entity = ent, text=richText}
}

local infos = {coverOpacity = 0}

local function clampPosition(x, y, width, height)
  local finalX, finalY = x, y
  if x < 0 then
    finalX = 0
  elseif x + width > 1280 then
    finalX = 1280-width
  end

  if y < 0 then
    finalY = 0
  elseif y + height > 1280 then
    finalY = 720-height
  end

  return finalX, finalY
end

local function setPositionAroundEntity(ent, x, y, width, height)
  local distance = 100
  local centerX, centerY = 640, 360
  
  local entCenterX = ent.x + (ent.width or 0) / 2
  local entCenterY = ent.y + (ent.height or 0) / 2
  
  local dx = centerX - entCenterX
  local dy = centerY - entCenterY
  local len = math.sqrt(dx * dx + dy * dy)
  
  if len > 0 then
    dx = dx / len
    dy = dy / len
  else
    dx, dy = 1, 0 -- Default direction if at center
  end
  
  local posX = entCenterX + dx * distance - width / 2
  local posY = entCenterY + dy * distance - height / 2
  
  return clampPosition(posX, posY, width, height)
end

system.on("@update", function ()
  for i, t in ipairs(targettedEnt) do
    t.entity.renderLayer = 1010
  end

  if #targettedEnt > 0 then
    flux.to(infos, 0.3, {coverOpacity=0.7})
  else
    flux.to(infos, 0.3, {coverOpacity=0})
    if infos.coverOpacity < 0.02 then
      infos.coverOpacity = 0
    end
  end
end)

system.on("@draw", function ()
  system.render(1008, function ()
    love.graphics.setColor(0.1, 0.1, 0.1, infos.coverOpacity)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
  end, true)

  for i, t in ipairs(targettedEnt) do
    local text = main.printRichText({
      format = t.text,
      renderLayer = 1010,
      x=t.entity:getX(),
      y=t.entity:getY(),
    })
    local w, h = text.richText:getWidth(), text.richText:getHeight()
    text.x, text.y = setPositionAroundEntity(t.entity, text.x-w/2+t.entity:getWidth()/2, text.y-h*1.5, w, h)
  end
end)

function main.addEntityToTutorial(ent, text)
  table.insert(targettedEnt, {originalRenderLayer=ent.renderLayer, entity=(ent.ui or ent), text=text})
end

function main.removeEntityFromTutorial(ent)
  for i, t in ipairs(targettedEnt) do
    local s = false
    local e = t.entity
    if e.isUI then
      if ent.isUI and e.index == ent.index then
        s = true
      elseif ent.ui and e.index == ent.ui.index then
        s = true
      end
    elseif ent.isUI ~= true and e.index == ent.index then
      s = true
    end

    if s then
      ent.renderLayer = t.originalRenderLayer
      table.remove(targettedEnt, i)
      break
    end
  end
end

function main.clearTutorial()
  targettedEnt = {}
end

system.on("main:entityDeleted", function (ent)
  main.removeEntityFromTutorial(ent)
end)