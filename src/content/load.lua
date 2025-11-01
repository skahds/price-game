system.on("@load", function ()
  for i=1, 3 do
    local card = main.createCard("multiply", {}, "hand")
    main.addCardToDraw(card)
  end

  for i=1, 3 do
    local card = main.createCard("quickOrb", {}, "hand")
    main.addCardToDraw(card)
  end

  for i=1, 3 do
    local card = main.createCard("subtract", {}, "hand")
    main.addCardToDraw(card)
  end

  for i=1, 2 do
    local card = main.createCard("amplifier", {}, "hand")
    main.addCardToDraw(card)
  end

  main.shuffleDraw()

  main.playScene("menu")
end)

-- system.on("@draw", function ()
--   main.printRichText({format="TEST",
--   y=100,
--   x=70,
--   renderLayer = 300,})
-- end)


-- local pipeline = main.getPipeline("main")
-- for i=1, 10 do
--   pipeline:add(0.3, function ()
--     system.playAudioWithPosition("boopMono", 0.01)
--   end)
-- end