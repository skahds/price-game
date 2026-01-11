main.definePatternsCard("goldenStar", {
  name = "Golden Star",
  image= "goldenStar",
  defaultMoneyGain=1,
  category="upgrade",
})

main.definePatternsCard("blossomMoon", {
  name = "Blossom Moon",
  image= "blossomMoon",
  multMultiplier = 2,
  category="upgrade",
})

main.definePatternsCard("cottonCandy", {
  name = "Cotton Candy",
  image= "cottonCandy",
  priceMultiplier = 2,
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

main.definePatternsCard("Materialization", {
  name = "Materialization",
  image= "materialization",
  defaultMoneyGain = -3,
  multMultiplier=3,
  category="upgrade",
})