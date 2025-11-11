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

system.on("@update", function ()
  for i, t in ipairs(targettedEnt) do
    t.entity.renderLayer = 1010
  end

  if #targettedEnt then
    flux.to(infos, 0.2, {coverOpacity=0.7})
  else
    flux.to(infos, 0.2, {coverOpacity=0})
    if infos.coverOpacity < 0.02 then
      infos.coverOpacity = 0
    end
  end
end)

system.on("main:entityDeleted", function (ent)
  for i, t in ipairs(targettedEnt) do
    if t.entity.index == ent.index then
      table.remove(targettedEnt, i)
      break
    end
  end
end)

system.on("@draw", function ()
  if #targettedEnt > 0 then
    system.render(1008, function ()
      love.graphics.setColor(0.1, 0.1, 0.1, infos.coverOpacity)
      love.graphics.rectangle("fill", 0, 0, 1280, 720)
    end, true)
  end

  for i, t in ipairs(targettedEnt) do
    local text = main.printRichText({
      format = t.text,
      renderLayer = 1010,
      x=t.entity:getX(),
      y=t.entity:getY(),
    })
    local w, h = text.richText:getWidth(), text.richText:getHeight()
    text.x, text.y = clampPosition(text.x-w/2+t.entity:getWidth()/2, text.y-h*1.5, w, h)
  end
end)

function main.addEntityToTutorial(ent, text)
  table.insert(targettedEnt, {originalRenderLayer=ent.renderLayer, entity=(ent.ui or ent), text=text})
end

function main.removeEntityFromTutorial(ent)
  for i, t in ipairs(targettedEnt) do
    if t.entity.index == ent.index then
      ent.renderLayer = t.originalRenderLayer
      table.remove(targettedEnt, i)
      break
    end
  end
end

function main.clearTutorial()
  targettedEnt = {}
end