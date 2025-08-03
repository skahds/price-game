system.on("main:entityTriggered", function (ent)
  if ent.temporary == nil then
    return
  end

  if ent.temporary > 0 then
    ent.temporary = ent.temporary - 1
  end
  if ent.temporary <= 0 then
    main.deleteEntity(ent)
  end
end)