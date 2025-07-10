local function richTextUpdate(ent)
  if ent.richtext == nil then
    return
  end
  local font = ent.richtext.font or system.getStorage("defaultFont")
  local textWidth = font:getWidth(ent.richtext.format)
  local textHeight = font:getHeight(ent.richtext.format)
  ent.richtext.x = ent.x+ent.width/2-textWidth/2
  ent.richtext.y = ent.y+ent.height/2-textHeight/2
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