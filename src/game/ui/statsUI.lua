system.on("@renderer:render", function ()
  system.render(200, function ()
    local money = system.getStorage("main:money")
    if money then
      love.graphics.print("Money: " .. money, 0, 100)
    end
  end, true)
end)