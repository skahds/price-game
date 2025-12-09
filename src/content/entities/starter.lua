local basicRoute = {
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=3},
  {id="PLAY", node=3},
  {id="SHOP", node=2},
  {id="PLAY", node=1},
}

local basicScoreRequired = {
  200,
  300,
  400,
  550,
  700,
  1000,
  2000
}

main.defineRunStarter({
  name = "Tutorial",
  description="Quick guide!",
  image = "basicAdd",
  route  = {
    {id="PLAY", node=1, reward={4}},
    {id="PLAY", node=3},
    {id="SHOP", node=2},
    {id="PLAY", node=3},
    {id="PLAY", node=3},
  },
  scoreRequirementList = basicScoreRequired,
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
  description="For the demo!",
  route = utils.deepCopy(basicRoute),
  scoreRequirementList = basicScoreRequired,
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
  description="14 days!",
  route = utils.deepCopy(basicRoute),
  scoreRequirementList = basicScoreRequired,
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
  image="stalemartyr",
  description="21 days!",
  route = utils.deepCopy(basicRoute),
  scoreRequirementList = basicScoreRequired,
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