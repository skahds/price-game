local offsetX = 0

system.on("@update", function ()
  offsetX = offsetX + system.getStorage("dt")
  if offsetX > math.pi*2 then
    offsetX = 0
  end
end)

system.answer("ui:getUIY", function (ent)
  if ent.parent and (ent.parent.isCard or ent.parent.isNews) then
    return math.sin((ent:getX()+offsetX*100)/100)*3
  end
  return 0
end)