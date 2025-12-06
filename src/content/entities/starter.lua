local basicRoute = {
  {id="PLAY", node=1, reward={4}},
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
  name = "TUTORIAL",
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

    -- main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "VENTURE",
  image="basicMultiply",
  description="for the demo!",
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