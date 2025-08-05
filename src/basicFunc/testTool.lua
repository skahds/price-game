system.on("@keyreleased", function (key)
  if key == "escape" then
    love.event.quit()
  end
end)

system.on("@renderer:render", function ()
  system.render(100, function ()
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()))
  end, true)
end)