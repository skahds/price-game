system.updateStorage("main:isOnTurn", false)

system.on("main:startTurn", function ()
  local chart = system.getStorage("main:chart")
  local pipeline = main.getPipeline("main")

  if system.getStorage("main:isOnTurn") == true then
    return
  end

  if chart then
    system.updateStorage("main:isOnTurn", true)
    main.triggerAllCardOwned("PRE")
    main.triggerAllNews("PRE")

    pipeline:add(0.2, function ()
      

      local bar = main.spawnBar()
      system.updateStorage("main:currentBar", bar)

    pipeline:add(0.2, function()

      -- do some stuff before ending turn
      main.triggerAllCardOwned("POST")
      main.triggerAllNews("POST")

    pipeline:add(0.2, function ()

      system.call("main:endTurn")
      system.updateStorage("main:isOnTurn", false)

    end)
    end)
    end)
  end
end)

system.on("main:endTurn", function ()
  local point = system.getStorage("main:point")
  local percentageHold = system.getStorage("main:ownedPercentage") or 0.5
  local bar = system.getStorage("main:currentBar")

  if bar then
    local change = bar.endPrice - bar.startPrice
    change = change * percentageHold/100 
    point = point + change
    system.updateStorage("main:point", point)
    system.call("main:pointChanged", change)
  end
end)