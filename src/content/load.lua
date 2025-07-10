-- love.graphics.setBackgroundColor(238/255, 225/255, 207/255)
love.graphics.setBackgroundColor(0.1, 0.1, 0.1)
system.on("@load", function ()
  
  main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
  color = {0.5, 0.5, 0.5},
  outlineColor = {0.4, 0.4, 0.4}, outline=20})
  main.ui.spawnUI("ownSlider", {x=50, y=10})
  main.ui.spawnUI("scaleYSlider", {x=1050, y=30})
  main.ui.spawnUI("startTurn", {x=80, y=550})
  main.ui.spawnUI("spawnCard", {x=80, y=450})
  main.spawnChart({bearPower = 0.2, bullPower = 0.2})
  local chart = system.getStorage("main:chart")

  -- for i=1, 1 do
  --   main.createCard("testCard", {})
  -- end

  
end)

-- system.on("@update", function ()

-- end)


-- local pipeline = main.getPipeline("main")
-- for i=1, 10 do
--   pipeline:add(0.01, function ()
--   system.playAudio("boop")
--   end)
-- end
