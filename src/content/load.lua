love.graphics.setBackgroundColor(1/3, 1/3, 1/3)
system.updateStorage("defaultFont", love.graphics.newFont(30))


system.on("@load", function ()
  main.ui.spawnUI("ownSlider", {x=10, y=20})
end)