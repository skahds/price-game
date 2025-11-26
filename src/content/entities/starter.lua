main.defineRunStarter({
  name = "TUTORIAL",
  description="Quick guide!",
  image = "basicAdd",
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
  onActivate = function ()
    main.createCardToDraw("cultivate", 3)
    main.createCardToDraw("dread", 3)
    main.createCardToDraw("greenHammer", 3)
    main.createCardToDraw("redHammer", 2)

    main.shuffleDraw()
  end
})