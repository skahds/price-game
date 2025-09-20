local canvasSize = 16*2
love.mouse.setVisible(false)
local isVisible = true

system.on("@draw", function ()
  system.render(10000, function ()
    local image
    local offset = 0
    if isVisible == false then
      love.graphics.setColor(1, 1, 1, 1)
      image = system.getImage("mouse2")
      offset = 8
    else
      image = system.getImage("mouse")
    end

    local mouse = system.getStorage("realMouse")
    love.graphics.draw(image, mouse.x, mouse.y, 0, 1, 1, offset, offset)
  end, true)
end)

system.on("ui:noUIHovered", function ()
  isVisible = true
end)

system.on("ui:UIHovered", function ()
  isVisible = false
end)