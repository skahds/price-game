system.on("startTurn", function ()
  local chart = system.getStorage("chart")
  if chart then
    local bar = main.spawnBar()
    system.updateStorage("currentBar", bar)

    -- do some stuff before ending turn
    system.call("endTurn")
  end
end)

system.on("endTurn", function ()
  local money = system.getStorage("main:money")
  local sliderPos = system.getStorage("main:ownSliderSlideAmount") or 0.5
  local percentageHold = (sliderPos-0.5)*200
  local bar = system.getStorage("currentBar")

  local change = bar.endPrice - bar.startPrice
  change = change * percentageHold/100 * (money/bar.startPrice)
  print("change: ", change, percentageHold, money)
  money = money + change
  system.updateStorage("main:money", money)
end)

-- system.on("@update", function ()
--   local bar = system.getStorage("currentBar")
--   if bar then
--     print(bar.barOrder)
--   end
-- end)