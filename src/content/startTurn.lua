system.on("startTurn", function ()
  local chart = system.getStorage("chart")
  if chart then
    local bar = main.spawnBar()
    system.updateStorage("currentBar", bar)
  end
end)

-- system.on("@update", function ()
--   local bar = system.getStorage("currentBar")
--   if bar then
--     print(bar.barOrder)
--   end
-- end)