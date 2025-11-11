system.on("@load", function ()
  main.playScene("menu")

  -- local bag = system.getStorage("rarity:bag")
  -- print(bag:getRandomNewsWithRarity("RARE"))
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