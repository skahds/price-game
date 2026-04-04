system.on("main:endTurn", function ()
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local pipeline = main.getPipeline("main")

  local scoreRequired = system.getStorage("main:scoreRequirement")
  local score = system.getStorage("main:score")

  if scoreRequired <= score then
    pipeline:add(0.1, function ()
      system.call("main:encounterEnd")
      local route = system.getStorage("main:route")
      local currentRoute = system.getStorage("main:currentRoute") or 1
      local cycle = system.getStorage("main:currentCycle")
      if cycle == #route and currentRoute == #route[#route] then
        system.updateStorage("main:gameResult", "WIN")
        main.playScene("gameEnd")
      else
        main.playScene("levelEnd")
      end
    end)
  elseif roundsRemaining <= 0 then
    pipeline:add(0.1, function ()
      system.call("main:encounterEnd")
      system.updateStorage("main:gameResult", "LOSE")
      main.playScene("gameEnd")
    end)
  end
end)