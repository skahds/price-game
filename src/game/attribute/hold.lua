main.defineComponent("hold", 0)

system.answer("main:shouldCardNotBeDiscared", function (ent)
  if ent.hold and ent.hold > 0 then
    ent.hold = ent.hold - 1
    return true
  end
end)