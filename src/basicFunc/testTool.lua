system.on("@keyreleased", function (key)
  if key == "escape" then
    main.openUITab("settings")
  end

  if key == "k" then
    for k, v in pairs(main.card.hand) do
      print(k, v, v.ui)
    end
  end
end)



-- system.on("@draw", function ()
--   system.render(1000, function ()
--     love.graphics.setColor(1, 1, 1)
--     local font = system.getFont("defaultFont30")
--     love.graphics.setFont(font)
--     love.graphics.print("Current FPS: "..tostring(love.timer.getFPS()))
--   end, true)
-- end)