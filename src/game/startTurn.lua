system.updateStorage("main:isOnTurn", false)
local pipeline = main.getPipeline("main")

local function updatePoint()
  local point = system.getStorage("main:point")
  local percentageHold = system.getStorage("main:ownedPercentage") or 0.5
  local bar = system.getStorage("main:currentBar")

  if bar then
    local change = math.floor((bar.endPrice - bar.startPrice)+0.5)
    local mult = system.getStorage("main:mult")
    change = change * percentageHold/100
    change = change * mult
    point = point + change
    system.updateStorage("main:point", point)
    system.call("main:pointChanged", change)
  end

  pipeline:add(0.1, function ()
    local scene = system.getStorage("main:currentScene")
    if scene == "play" then
      main.discardCurrentCardsInHand()
      pipeline:add(0.1, function ()
        main.drawCardTillMaxCapacity()
      end)
    end
  end)

  system.updateStorage("main:mult", 1)
end

system.on("main:startTurn", function ()
  local chart = system.getStorage("main:chart")

  if system.getStorage("main:isOnTurn") == true then
    return
  end

  if chart then
    system.updateStorage("main:isOnTurn", true)

    local roundsRemaining = system.getStorage("main:roundsRemaining")
    system.updateStorage("main:roundsRemaining", roundsRemaining-1)
    pipeline:add(0.2, function()

      local bar = system.getStorage("main:currentBar")
      main.basicBarSpawnChange(bar, chart)

    pipeline:add(0.2, function()

      main.triggerAllCardOwned("POST")

    end)
    end)
  end
end)

system.on("main:repeatingTriggerCardEnd", function (trigger)
  if trigger ~= "POST" then
    return
  end

  pipeline:add(0.2, function ()

    main.triggerAllNews("POST")

  end)
end)

system.on("main:repeatingTriggerNewsEnd", function (trigger)
  if trigger ~= "POST" then
    return
  end

  pipeline:add(0.2, function ()

    updatePoint()

  pipeline:add(0.2, function ()

    system.call("main:endTurn")
    system.updateStorage("main:isOnTurn", false)

  pipeline:add(0.2, function ()

    local bar = main.spawnBar()
    system.updateStorage("main:currentBar", bar)

  end)
  end)
  end)
end)