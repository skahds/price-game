system.on("@load", function ()
  for i=1, 10 do
    local card = main.createCard("testCard", {}, "hand")
    main.addCardToDraw(card)
  end
  local card = main.createCard("bounceSpawner", {}, "hand")
  main.addCardToDraw(card)
  local card2 = main.createCard("amplifier", {}, "hand")
  main.addCardToDraw(card2)
  local card3 = main.createCard("amplifier", {}, "hand")
  main.addCardToDraw(card3)

  main.playScene("shop")
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