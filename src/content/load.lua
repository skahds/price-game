system.on("@load", function ()
  main.playScene("shop")

  for i=1, 10 do
    local card = main.createCard("testCard", {}, "hand")
    main.addCardToDraw(card)
  end
end)

-- system.on("@update", function ()

-- end)


-- local pipeline = main.getPipeline("main")
-- for i=1, 10 do
--   main.playScene("shop")
--   main.playScene("play")
-- end
