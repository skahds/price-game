-- love.graphics.setBackgroundColor(238/255, 225/255, 207/255)
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)


system.on("@load", function ()
  local slider = main.ui.spawnUI("ownSlider", {x=10, y=300}, true)
  main.ui.spawnUI("startTurn", {x=20, y=20})
  main.spawnChart({bearPower = 0.2, bullPower = 0.2})
  local chart = system.getStorage("main:chart")
  main.createCard({})
end)