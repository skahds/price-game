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

system.answer("main:shouldCardNotBeDiscared", function (card)
  if card.temporary and card.temporary > 1 then
    return true
  end
  return false
end)