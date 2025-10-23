system.on("main:endTurn", function ()
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local pipeline = main.getPipeline("main")

  local pointRequired = system.getStorage("main:pointRequirement")
  local point = system.getStorage("main:point")

  if pointRequired <= point then
    pipeline:add(0.1, function ()
      local currentLevel = system.getStorage("main:currentLevel")
      if currentLevel == 5 then
        system.updateStorage("main:gameResult", "WIN")
        main.playScene("gameEnd")
      else
        main.playScene("levelEnd")
      end
    end)
  elseif roundsRemaining <= 0 then
    pipeline:add(0.1, function ()
      system.updateStorage("main:gameResult", "LOSE")
      main.playScene("gameEnd")
    end)
  end
end)