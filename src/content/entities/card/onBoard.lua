main.definePlaceableNewsCard("expound", {
  name = "Expound",
  image = "expound",
  trigger= {"DEPLOY"},
  price=4,
  rarity = "RARE"
}, {
  image = "expoundNews",
  trigger = {"ROUND"},
  description="For each news in area,\ngive {multColor}+2 MULT{/multColor}",
  target={
    shape = {w=3, h=3},
    onActivate = function (ent, targetEnt)
      main.addMult(2)
    end
  }
})