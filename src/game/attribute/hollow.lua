main.defineComponent("hollow", false)

system.answer("main:cardSpaceUsed", function (ent)
  if ent.hollow  then
    return -1
  end
end)