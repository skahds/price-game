local combo = 0

system.on("main:entityTriggered", function ()
  combo = combo + 1
end)

system.on("main:endTurn", function ()
  combo = 0
end)


system.on("@update", function ()
  system.updateStorage("main:currentCombo", combo)
end)