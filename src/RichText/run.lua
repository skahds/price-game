local textTable = system.getStorage("textsTable")

system.on("@update", function ()
  for _, t in pairs(textTable) do
    local text = t.richText
    text:update()
  end
end)

system.on("@renderer:render", function ()

  for _, t in pairs(textTable) do
    local fixed = true
    if t.screenSpace == false then
      fixed = false
    end

    system.render(t.renderLayer or 50, function ()
      local text = t.richText
      love.graphics.setColor(t.color or {1, 1, 1})
      text:draw(t.x or 0, t.y or 0, t.r or 0, t.sx or 1, t.sy or 1, t.ox or 0, t.oy or 0)
    end, fixed)
  end

end)