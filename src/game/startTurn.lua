system.on("main:startTurn", function ()
  local chart = system.getStorage("main:chart")
  if chart then
    local bar = main.spawnBar()
    system.updateStorage("main:currentBar", bar)

    -- do some stuff before ending turn
    main.wait(0.5, function ()
      system.call("main:endTurn")
    end)
  end
end)

system.on("main:endTurn", function ()
  local money = system.getStorage("main:money")
  local sliderPos = system.getStorage("main:ownSliderSlideAmount") or 0.5
  local percentageHold = (sliderPos-0.5)*200
  local bar = system.getStorage("main:currentBar")

  local change = bar.endPrice - bar.startPrice
  change = change * percentageHold/100 * (money/bar.startPrice)
  money = money + change
  system.updateStorage("main:money", money)
  system.call("main:moneyChanged")
end)

-- system.on("@update", function ()
--   local bar = system.getStorage("main:currentBar")
--   if bar then
--     print(bar.barOrder)
--   end
-- end)