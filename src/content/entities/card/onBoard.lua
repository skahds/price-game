main.definePlaceableNewsCard("expound", {
  name = "Expound",
  image = "expound",
  trigger= {"DEPLOY"},
  price=3,
  rarity = "RARE"
}, {
  image = "expoundNews",
  trigger = {"ROUND"},
  description="Target news gains {multColor}+2 MULT",
  target={
    shape = {w=3, h=3},
    onActivate = function (ent, targetEnt)
      main.changeEntityComponent(targetEnt, "defaultMultGain", 2, combiner.ADD)
    end
  }
})