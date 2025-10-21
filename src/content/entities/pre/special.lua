main.defineCard("scale", {
  name = "Scale",
  image = "scale",
  description = "If Bar direction is\ndifferent than the last, gain\n{multColor}+1 mult{/multColor}, else {multColor}-1 mult{/multColor}",
  trigger = {"POST"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local secondToLast = chart:getBar(-2)
    local last = chart:getBar(-1)
    if secondToLast == nil or
    (last.endPrice - last.startPrice) * (last.endPrice-last.startPrice) < 0 then
      main.changeEntityComponent(ent, "defaultMultGain", 1, combiner.ADD)
    else
      main.changeEntityComponent(ent, "defaultMultGain", -1, combiner.ADD)
    end
  end
})
