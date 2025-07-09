-- love.graphics.setBackgroundColor(238/255, 225/255, 207/255)
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
system.on("@load", function ()
  main.ui.spawnUI("ownSlider", {x=20, y=600})
  main.ui.spawnUI("scaleYSlider", {x=1050, y=30})
  main.ui.spawnUI("startTurn", {x=10, y=20})
  main.ui.spawnUI("spawnCard", {x=150, y=20})
  main.spawnChart({bearPower = 0.2, bullPower = 0.2})
  local chart = system.getStorage("main:chart")

  for i=1, 1 do
    main.createCard("testCard", {})
  end
  main.card.updateAllCardPositionBackToOriginalPosition()

  
end)

-- system.on("@update", function ()

-- end)


-- local pipeline = main.getPipeline("main")
-- for i=1, 10 do
--   pipeline:add(0.01, function ()
--   system.playAudio("boop")
--   end)
-- end
