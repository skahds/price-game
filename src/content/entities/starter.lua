local basicRoute = {
  {id="PLAY", node=3},
  {id="PLAY", node={2, 3}},
  {id="PLAY", node={2, 3}},
  {id="SHOP", node=2},
  {id="PLAY", node=2},
  {id="PLAY", node={2, 3}, enemy={"oracle", "regulator"}},
  {id="PLAY", node={2, 3}, enemy={"straw"}},
  {id="SHOP", node=2},
  {id="PLAY", node=2},
  {id="PLAY", node={2, 3}, enemy={"trap"}},
  {id="PLAY", node={2, 3}, enemey={"fog"}},
  {id="SHOP", node=2},
  {id="PLAY", node=1, enemy={"machine"}},
}

local basicScoreRequired = {{
  400,
  600,
  800,
  1400,
  2000,
  2800,
  5000,
  7500,
  10000,
  20000,
},{
  400,
  600,
  800,
  1600,
  3000,
  4000,
  8000,
  12000,
  16000,
  40000,
}, {
  400,
  700,
  900,
  2000,
  3500,
  5000,
  11000,
  20000,
  30000,
  80000,
}}

main.defineRunStarter({
  name = "Tutorial",
  description="Quick guide!",
  image = "basicAdd",
  route  = {
    {id="PLAY", node=1, reward={4}},
    {id="PLAY", node=3},
    {id="SHOP", node=2},
    {id="PLAY", node=3, enemy={"regulator"}},
    {id="PLAY", node=1, enemy={"fog"}},
  },
  scoreWithDifficulty = {{400, 600, 800, 1400, 2000,}},
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("amplifier", 2)

    system.updateStorage("main:isDoingTutorial", true)
    -- main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "Venture",
  image="basicMultiply",
  description="Normal deck",
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("amplifier", 2)

    main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "Firm",
  image="vision",
  description="NOT IMPLEMENTED",
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("amplifier", 2)

    main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "Enterprise",
  image="sigil",
  description="NOT IMPLEMENTED",
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("amplifier", 2)

    main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "Association",
  image="radar",
  description="NOT IMPLEMENTED",
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("amplifier", 2)

    main.shuffleDraw()
  end
})

-- main.defineRunStarter({
--   name = "TEST",
--   image="basicMultiply",
--   description="i need something!",
--   route  = {
--     {id="PLAY", node=1, reward={4}},
--     {id="PLAY", node=3},
--     {id="SHOP", node=2},
--     {id="PLAY", node=3},
--     {id="PLAY", node=3},
--   },
--   scoreRequirementList = {550, 700, 1000, 2000},
--   onActivate = function ()
--     main.createCardToDraw("add", 1)
--     main.createCardToDraw("subtract", 1)
--     main.createCardToDraw("multiply", 1)
--     main.createCardToDraw("drag", 1)
--     main.createCardToDraw("relay", 1)
--     main.createCardToDraw("decomposite", 1)
--     main.createCardToDraw("sigil", 1)
--     main.createCardToDraw("vision", 1)
--     main.createCardToDraw("chainReaction", 1)
--     main.createCardToDraw("amplifier", 2)

--     main.shuffleDraw()
--   end
-- })