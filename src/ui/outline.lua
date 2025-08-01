system.on("ui:entityDrawn", function (ent)
  if ent.outline == nil then
    return
  end
  local outlineColor = ent.outlineColor or {1, 1, 1, 1}

  system.render(ent.renderLayer+1, function ()
    love.graphics.setLineWidth(ent.outline)
    love.graphics.setColor(outlineColor)
    love.graphics.rectangle("line", ent.x, ent.y, ent:getWidth(), ent:getHeight())
  end, ent.screenSpace)
end)