main.definePlaceableNewsCard("expound", {
  name = "Expound",
  image = "expound",
  trigger= {"DEPLOY"},
  price=4,
  rarity = "RARE"
}, {
  image = "expoundNews",
  trigger = {"ROUND"},
  description="Give {multColor}+3 MULT{/multColor}",
  onActivate = function (ent, targetEnt)
    main.addMult(3)
  end
})