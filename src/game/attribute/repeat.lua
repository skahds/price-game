system.on("main:entityTriggered", function (ent)
  if ent.repeatActivation == nil or ent.repeatActivation <= 0 then
    return
  end

  ent.repeatActivation = ent.repeatActivation - 1
  
  local pipeline = main.getPipeline("main")
  pipeline:insert(0.3, 1, function ()
    main.triggerEnt(ent)
  end)
end)