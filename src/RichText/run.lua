local textTable = system.getStorage("textsTable")

system.on("@update", function ()
  for _, t in pairs(textTable) do
    local text = t.text
    text:update()
  end
end)

system.on("@renderer:render", function ()
  system.render(300, function ()
    for _, t in pairs(textTable) do
      local text = t.text
      text:draw(t.x or 0, t.y or 0)
    end
  end, true)
end)