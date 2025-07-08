system.on("main:startTurn", function ()
  local chart = system.getStorage("main:chart")
  local pipeline = main.getPipeline("main")
  if chart then
    main.triggerAllCardOwned("PRE")

    pipeline:add(0.5, function ()
      

      local bar = main.spawnBar()
      system.updateStorage("main:currentBar", bar)

    pipeline:add(0.5, function()

      -- do some stuff before ending turn
      main.triggerAllCardOwned("POST")

    pipeline:add(0.5, function ()

      system.call("main:endTurn")

    end)
    end)
    end)
  end
end)

system.on("main:endTurn", function ()
  local money = system.getStorage("main:money")
  local percentageHold = system.getStorage("main:ownedPercentage") or 0.5
  local bar = system.getStorage("main:currentBar")

  if bar then
    local change = bar.endPrice - bar.startPrice
    change = change * percentageHold/100 * (money/bar.startPrice)
    money = money + change
    system.updateStorage("main:money", money)
    system.call("main:moneyChanged", change)
  end
end)