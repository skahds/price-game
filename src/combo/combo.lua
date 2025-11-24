local combo = 0

system.on("main:entityTriggered", function (ent)
  if ent.isCard then
    return
  end
  combo = combo + 1
end)

system.on("main:endTurn", function ()
  combo = 0
end)


system.on("@update", function ()
  local pipeline = main.getPipeline("main")
  if pipeline then
    if #pipeline.pipeline == 0 then
      combo = 0
    end
  end

  system.updateStorage("main:currentCombo", combo)
end)