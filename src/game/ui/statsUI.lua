system.on("@renderer:render", function ()
  system.render(200, function ()
    local money = system.getStorage("main:money")
    if money then
      love.graphics.print("$" .. math.floor(money+0.5), 80, 200)
    end
  end, true)
end)