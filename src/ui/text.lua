local function richTextUpdate(ent)
  if ent.richtext == nil then
    return
  end
  local font = ent.richtext.font or system.getStorage("defaultFont")
  ent.richtext.sx = ent.sx
  ent.richtext.sy = ent.sy
  local textWidth = ent.richtext.richText:getWidth()
  local textHeight = font:getHeight(ent.richtext.format)
  ent.richtext.x = ent.x-ent.ox*ent.sx+ent:getWidth()/2-textWidth/2*ent.sx
  ent.richtext.y = ent.y-ent.oy*ent.sy+ent:getHeight()/2-textHeight/2*ent.sy
end

system.on("ui:spawnedUI", function (ent)
  if ent.text then
    ent.richtext = main.newRichText({format=ent.text,
    x=ent.x,
    y=ent.y,
    screenSpace = ent.screenSpace,
    renderLayer = ent.renderLayer+1})
  end
end)

system.on("ui:entityDrawn", function (ent)
  richTextUpdate(ent)
end)

system.on("ui:entityDeleted", function (ent)
  if ent.richtext == nil then
    return
  end

  ent.richtext:delete()
end)