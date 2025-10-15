main.defineComponent("isHollow", false)

system.answer("main:cardSpaceUsed", function (ent)
  if ent.isHollow  then
    return -1
  end
end)