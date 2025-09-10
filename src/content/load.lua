system.on("@load", function ()
  main.playScene("menu")

  for i=1, 10 do
    local card = main.createCard("testCard", {}, "hand")
    main.addCardToDraw(card)
  end

end)

-- system.on("@update", function ()

-- end)


-- local pipeline = main.getPipeline("main")
-- for i=1, 10 do
--   pipeline:add(0.3, function ()
--     system.playAudioWithPosition("boopMono", 0.01)
--   end)
-- end