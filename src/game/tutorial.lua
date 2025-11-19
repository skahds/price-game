local flux = system.getStorage("flux")
local font = system.getFont("defaultFont50")

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
    t.entity.renderLayer = math.max(310, t.entity.renderLayer)
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
  system.render(309, function ()
    love.graphics.setColor(0.1, 0.1, 0.1, infos.coverOpacity)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
  end, true)

  for _, t in ipairs(targettedEnt) do
    local textTable = utils.seperateSlashN(t.text)
    for i, str in ipairs(textTable) do
      local x = t.entity:getX()
      local y = t.entity:getY()
      if t.entity.screenSpace == false or (t.entity.ui and t.entity.ui.screenSpace == false) then
        x, y = main.worldPositionToScreenSpace(x, y)
      end

      local text = main.printRichText({
        format = str,
        renderLayer = 330,
        x=x,
        y=y,
        font=font,
      })
      local w, h = text.richText:getWidth(), text.richText:getHeight()
      local extraHeight = text.richText:getHeight()*(i-1)
      local yPos
      if y+t.entity:getHeight()/2 > 360 then
        yPos = text.y-h*(0.5+#textTable) + extraHeight
      else
        yPos = text.y+t.entity:getHeight()+h*0.5 + extraHeight
      end

      text.x, text.y = clampPosition(text.x-w/2+t.entity:getWidth()/2, yPos, w, h)
    end
  end
end)

function main.addEntityToTutorial(ent, text)
  table.insert(targettedEnt, {entity=(ent.ui or ent), text=text, originalPosition={x=ent.x, y=ent.y}})
  local e = targettedEnt[#targettedEnt]
  e.originalRenderLayer = e.entity.renderLayer
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
  for i, t in ipairs(targettedEnt) do
    t.entity.renderLayer = t.originalRenderLayer
  end
  targettedEnt = {}
end

system.on("main:entityDeleted", function (ent)
  main.removeEntityFromTutorial(ent)
end)