local combo = 0

local lastActivated
system.on("main:entityTriggered", function (ent)
  if ent.isCard then
    combo = combo + 1

    lastActivated = "card"
  elseif ent.isNews then
    if lastActivated == "news" then
      combo = combo + 1
    else
      combo = 1
    end

    lastActivated = "news"
  end
end)

system.on("main:endTurn", function ()
  combo = 0
end)


system.on("@update", function ()
  local pipeline = main.getPipeline("main")
  if pipeline then
    if #pipeline.pipeline == 0 then
      combo = 0
      lastActivated = nil
    end
  end

  system.updateStorage("main:currentCombo", combo)
end)