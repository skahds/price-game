local textTable = system.getStorage("textsTable")

system.on("@update", function ()
  for _, t in pairs(textTable) do
    local text = t.richText
    text:update()
  end
end)

local function drawOutline(t)
  local fixed = true
  if t.screenSpace == false then
    fixed = false
  end

  local renderLayer = t.renderLayer or 50
  system.render(renderLayer, function ()
    local text = t.richText
    local x = t.x or 0
    local y = t.y or 0
    local r = t.r or 0
    local sx = t.sx or 1
    local sy = t.sy or 1
    local ox = t.ox or 0
    local oy = t.oy or 0
    local color
    if t.color then
      color = {t.color[1]/1.5, t.color[2]/1.5, t.color[3]/1.5}
    else
      color = {0.7, 0.7, 0.7}
    end
    
    love.graphics.setColor(color)
    text:draw(x-2, y-2, r, sx, sy, ox, oy)
    text:draw(x-2, y+2, r, sx, sy, ox, oy)
    text:draw(x+2, y+2, r, sx, sy, ox, oy)
    text:draw(x+2, y-2, r, sx, sy, ox, oy)
  end, fixed)
end

system.on("@renderer:render", function ()

  for _, t in pairs(textTable) do
    local fixed = true
    if t.screenSpace == false then
      fixed = false
    end

    if t.outline then
      drawOutline(t)
    end

    system.render(t.renderLayer or 50, function ()
      local text = t.richText
      local x = t.x or 0
      local y = t.y or 0
      local r = t.r or 0
      local sx = t.sx or 1
      local sy = t.sy or 1
      local ox = t.ox or 0
      local oy = t.oy or 0
      love.graphics.setColor(t.color or {1, 1, 1})
      text:draw(x, y, r, sx, sy, ox, oy)
    end, fixed)
  end

end)