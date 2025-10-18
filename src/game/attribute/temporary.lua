main.defineComponent("temporary", math.huge)

local pipeline = main.getPipeline("main")

system.on("main:entityTriggered", function (ent)
  if ent.temporary == nil then
    return
  end

  if ent.temporary > 0 then
    ent.temporary = ent.temporary - 1
  end
  if ent.temporary <= 0 then
    pipeline:add(0.1, function ()
      main.tryDestroyEntity(ent)
    end)
  end
end)