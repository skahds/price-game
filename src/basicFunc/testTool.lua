system.on("@keyreleased", function (key)
  if key == "escape" then
    main.ui.gameSettings()
  end
end)

system.on("@draw", function ()
  system.render(1000, function ()
    love.graphics.setColor(1, 1, 1)
    local font = system.getFont("defaultFont30")
    love.graphics.setFont(font)
    love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()))
  end, true)
end)