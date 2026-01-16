main.definePatternsCard("goldenStar", {
  name = "Golden Star",
  image= "goldenStar",
  defaultMoneyGain= 2,
  category="upgrade",
})

main.definePatternsCard("blossomMoon", {
  name = "Blossom Moon",
  image= "blossomMoon",
  defaultMultMultiplier = 2,
  category="upgrade",
})

main.definePatternsCard("cottonCandy", {
  name = "Cotton Candy",
  image= "cottonCandy",
  defaultPriceMultiplier = 2,
  category="upgrade",
})

main.definePatternsCard("immaterialization", {
  name = "Immaterialization",
  image= "immaterialization",
  description = "Create a Void",
  descriptionTagEntity = "void",
  onActivate = function ()
    main.basicSpawnCard("void", {}, nil, "hand")
  end,
  category="upgrade",
})

main.definePatternsCard("materialization", {
  name = "Materialization",
  image= "materialization",
  defaultMoneyGain = -3,
  defaultMultMultiplier=3,
  category="upgrade",
})

main.definePatternsCard("metronome", {
  name = "Metronome",
  image= "metronome",
  description="Gains {multColor}X0.5 MULT",
  onActivate = function (ent)
    main.changeEntityComponent(ent, "multMultiplier", 0.5, combiner.ADD)
  end,
  category="upgrade",
})