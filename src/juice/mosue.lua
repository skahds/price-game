local canvasSize = 16*2
love.mouse.setVisible(false)

system.on("@draw", function ()
  system.render(10000, function ()
    local mouse = system.getStorage("realMouse")
    local image = system.getImage("mouse")
    love.graphics.draw(image, mouse.x, mouse.y)
  end, true)
end)