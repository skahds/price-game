system.on("ui:entityDrawn", function (ent)
  if ent.outline == nil or ent.outline == 0 then
    return
  end
  local outlineColor = ent.outlineColor or {1, 1, 1, 1}
  local outlineBelow = ent.outlineBelow or false
  local renderLayer
  if outlineBelow then
    renderLayer = ent.renderLayer - 1
  else
    renderLayer = ent.renderLayer + 1
  end

  system.render(renderLayer, function ()
    love.graphics.setLineWidth(ent.outline)
    love.graphics.setColor(outlineColor)
    local ox = (ent.ox or 0) * (ent.sx or 1)
    local oy = (ent.oy or 0) * (ent.sy or 1)
    love.graphics.rectangle("line", ent.x-ox, ent.y-oy, ent:getWidth(), ent:getHeight(), ent.rx, ent.ry)
  end, ent.screenSpace)

  if ent.onSlide then
    system.render(renderLayer, function ()
      love.graphics.setColor(outlineColor)
      local r = math.min(ent.width, ent.height)/2 + ent.outline/2
      love.graphics.circle("fill", ent.x, ent.y+ent.height/2, r)
      love.graphics.circle("fill", ent.x+ent.width, ent.y+ent.height/2, r)
    end, ent.screenSpace)
  end
end)