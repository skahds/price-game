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

    pipeline:add(0.2, function ()

      main.triggerAllNews("PRE")

    pipeline:add(0.2, function ()

      local bar = main.spawnBar()
      system.updateStorage("main:currentBar", bar)

    pipeline:add(0.2, function()

      main.triggerAllCardOwned("POST")

    pipeline:add(0.2, function ()

      main.triggerAllNews("POST")

    pipeline:add(0.2, function ()

      system.call("main:endTurn")
      system.updateStorage("main:isOnTurn", false)

    end)
    end)
    end)
    end)
    end)
  end
end)

system.on("main:endTurn", function ()
  local pipeline = main.getPipeline("main")
  local point = system.getStorage("main:point")
  local percentageHold = system.getStorage("main:ownedPercentage") or 0.5
  local bar = system.getStorage("main:currentBar")

  if bar then
    local change = math.floor((bar.endPrice - bar.startPrice)+0.5)
    change = change * percentageHold/100 
    point = point + change
    system.updateStorage("main:point", point)
    system.call("main:pointChanged", change)
  end

  pipeline:add(0.1, function ()
    main.discardCurrentCardsInHand()
    pipeline:add(0.1, function ()
      main.drawCardTillMaxCapacity()
    end)
  end)
end)