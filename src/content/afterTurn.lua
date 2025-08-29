local roundPerDay = 3

system.on("main:endTurn", function ()
  local chart = system.getStorage("main:chart")
  local counter = 0
  chart:forAllBar(function ()
    counter = counter + 1
  end)

  if counter >= roundPerDay then
    local pipeline = main.getPipeline("main")
    -- show some day-end ui
    pipeline:add(0.1, function ()
      main.playScene("shop")
    end)
  end
end)