main.defineRunStarter({
  name = "TUTORIAL",
  description="Please play this",
  onActivate = function ()
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("amplifier", 2)

    -- main.shuffleDraw()
  end
})

main.defineRunStarter({
  name = "VENTURE",
  description="Not that hard tbh",
  onActivate = function ()
    main.createCardToDraw("multiply", 3)
    main.createCardToDraw("add", 3)
    main.createCardToDraw("subtract", 3)
    main.createCardToDraw("amplifier", 2)

    -- main.shuffleDraw()
  end
})