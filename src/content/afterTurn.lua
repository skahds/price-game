system.on("main:endTurn", function ()
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local pipeline = main.getPipeline("main")

  local pointRequired = system.getStorage("main:pointRequirement")
  local point = system.getStorage("main:point")

  if pointRequired <= point then
    pipeline:add(0.1, function ()
      main.playScene("levelEnd")
    end)
  elseif roundsRemaining <= 0 then
    pipeline:add(0.1, function ()
      system.updateStorage("main:gameResult", "LOSE")
      main.playScene("gameEnd")
    end)
  end
end)