local basicRoute = {
  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  },

  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  },

  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  },

  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  },

  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  },

  {
    {id="PLAY", node=3},
    {id="PLAY", node={2, 3}},
    {id="PLAY", node={2, 3}, enemy="elite"},
    {id="SHOP", node=2},
    {id="PLAY", node=1, enemy="boss"},
  }
}

if isDemo then
  table.remove(basicRoute, #basicRoute)
  table.remove(basicRoute, #basicRoute)
end

local basicScoreRequired = {{
  changeInCycle = 0.3, --1x, 1.3x, 1.6x, 2.5x, 3.5x
  bossScore = 2.5,
  cycles = {400, 1500, 5000, 20000, 80000, 300000}, -- approx 3-4x per cycle
  creditMult = 1,
},{
  changeInCycle = 0.6, --1x, 1.6x, 2.2x, 3x, 4x?
  bossScore = 3,
  cycles = {400, 1800, 7000, 30000, 150000, 1000000},
  creditMult = 1.5,
}, {
  changeInCycle = 0.8, --1x, 1.8x, 2.6x, 4x, 5x?
  bossScore = 4,
  cycles = {400, 2000, 10000, 50000, 250000, 2500000},
  creditMult = 2,
}} -- change this?

main.defineRunStarter("tutorial", {
  name = "Tutorial",
  description="Quick guide!",
  image = "basicAdd",
  route  = { -- TOBE IMPLEMENTED
    {
      {id="PLAY", node=1, reward={4}},
      {id="PLAY", node=3},
      {id="PLAY", node=3, enemy="elite"},
      {id="SHOP", node=2},
      {id="PLAY", node=1, enemy="boss"},
    },
    {
      {id="PLAY", node=1, reward={4}},
      {id="PLAY", node=3},
      {id="PLAY", node=3, enemy="elite"},
      {id="SHOP", node=2},
      {id="PLAY", node=1, enemy="boss"},
    }
  },
  scoreWithDifficulty = {{
    changeInCycle = 0.3, --1x, 1.3x, 1.6x, 2x, 3x
    bossScore = 2,
    cycles = {400, 1200}, -- approx 3-4x per cycle
  }},
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("amplifier", 2)

    system.updateStorage("main:isDoingTutorial", true)
    -- main.shuffleDraw()
  end
})

main.defineRunStarter("venture", {
  name = "Venture",
  image="amplifier",
  achievementID = "WIN_VENTURE",
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

main.defineRunStarter("firm", {
  name = "Firm",
  image="holopot",
  demoLocked=true,
  achievementID = "WIN_FIRM",
  description="Draw deck",
  unlock = {type="credits"},
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("adder", 3)
    main.createCardToDraw("subtracter", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("holopot", 2)

    main.shuffleDraw()
  end
})

main.defineRunStarter("enterprise", {
  name = "Enterprise",
  image="reserve",
  demoLocked=true,
  achievementID = "WIN_ENTERPRISE",
  description="Energy deck",
  unlock = {type="credits"},
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("reserve", 1)
    main.createCardToDraw("shift", 1)

    main.shuffleDraw()
  end
})

main.defineRunStarter("association", {
  name = "Association",
  image="highway",
  demoLocked=true,
  achievementID = "WIN_ASSOCIATION",
  description="Money deck",
  unlock = {type="credits"},
  route = utils.deepCopy(basicRoute),
  scoreWithDifficulty = basicScoreRequired,
  onActivate = function ()
    main.createCardToDraw("add", 2)
    main.createCardToDraw("subtract", 2)
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("highway", 2)
    main.createCardToDraw("greedEngine", 1)
    main.createCardToDraw("fearEngine", 1)
    main.shuffleDraw()
  end
})

-- main.defineRunStarter("test", {
--   name = "TEST",
--   image="basicMultiply",
--   description="i need something!",
--   route = utils.deepCopy(basicRoute),
--   scoreWithDifficulty = basicScoreRequired,
--   onActivate = function ()
--     main.createCardToDraw("add", 1)
--     main.createCardToDraw("sigil", 3)
--     main.createCardToDraw("augment", 1)
--     main.createCardToDraw("doubleDown", 1)
--     main.createCardToDraw("holopot", 3)
--     -- main.createCardToDraw("holopot", 1)
--     -- main.createCardToDraw("highway", 1)
--     -- main.createCardToDraw("drag", 1)
--     -- main.createCardToDraw("relay", 1)
--     -- main.createCardToDraw("decomposite", 1)
--     -- main.createCardToDraw("sigil", 1)
--     -- main.createCardToDraw("vision", 1)
--     -- main.createCardToDraw("chainReaction", 1)
--     -- main.createCardToDraw("amplifier", 2)

--     main.shuffleDraw()
--   end
-- })

-- main.defineRunStarter("test", {
--   name = "Association",
--   image="basicMultiply",
--   description="i need something!",
--   route = utils.deepCopy(basicRoute),
--   scoreWithDifficulty =  {{
--     changeInCycle = 0.8, --1x, 1.8x, 2.6x, 4x, 5x?
--     bossScore = 4,
--     cycles = {0, 2000, 10000, 50000, 250000, 2500000},
--     creditMult = 2,
--   }},
--   onActivate = function ()
--     system.updateStorage("main:currentCycle", 4)
--     system.updateStorage("main:currentRoute", 3)
--     main.spawnNews("refine", {x=0,y=0})
--     main.spawnNews("dream", {x=0,y=0})
--     main.spawnNews("warBanner", {x=0,y=0})
--     main.spawnNews("sceptre", {x=0,y=0})
--     main.addMoney(32)
--     -- main.spawnNews("dream", {x=0,y=0})
--     main.createCardToDraw("add", 1)
--     main.createCardToDraw("subtract", 1)
--     main.createCardToDraw("multiply", 2)
--     main.createCardToDraw("highway", 2)
--     main.createCardToDraw("greedEngine", 1)
--     main.createCardToDraw("fearEngine", 1)
--     -- main.createCardToDraw("shift", 1)
--     main.createCardToDraw("radar", 1)
--     -- main.createCardToDraw("drag", 1)
--     -- main.createCardToDraw("expound", 1)
--     main.createCardToDraw("vision", 1)
--     main.createCardToDraw("sigil", 1)
--     main.createCardToDraw("augment", 1)
--     main.createCardToDraw("doubleDown", 1)
--     -- main.createCardToDraw("doubleDown", 1)
--     -- main.createCardToDraw("augment", 1)
--     -- main.createCardToDraw("holopot", 3)
--     -- main.createCardToDraw("highway", 1)
--     -- main.createCardToDraw("drag", 1)
--     -- main.createCardToDraw("relay", 1)
--     -- main.createCardToDraw("decomposite", 1)
--     -- main.createCardToDraw("sigil", 1)
--     -- main.createCardToDraw("vision", 1)
--     -- main.createCardToDraw("chainReaction", 1)
--     -- main.createCardToDraw("amplifier", 2)
--     -- main.createCardToDraw("reap", 1)

--     main.shuffleDraw()
--   end
-- })