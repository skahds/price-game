main.defineComponent("isRelic", false)

system.answer("main:shouldCardNotBeDiscared", function (ent)
  if ent.isRelic == true then
    return true
  end
end)