system.on("@renderer:render", function ()
  system.render(200, function ()
    local money = system.getStorage("main:money")
    if money then
      love.graphics.print("Money: " .. math.floor(money+0.5), 0, 150)
    end
  end, true)
end)