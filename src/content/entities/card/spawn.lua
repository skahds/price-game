-- main.defineCard("bounceSpawner", {
--   name = "bounce Card",
--   image = "bounceCard",
--   description = "test\nwith \\n",
--   trigger = {"ROUND"},
--   onActivate = function (ent)
--     local chart = system.getStorage("main:chart")
--     local pos = chart:getCurrentPricePos()

--     if pos == nil then
--       return
--     end

--     local yoffset
--     if pos.direction == 1 then
--       yoffset = pos.height - love.math.random(0, 60)
--     else
--       yoffset = -love.math.random(0, 60)
--     end
--     local xoffset = pos.width
--     main.spawnNews("bouncer", {x=pos.x+xoffset, y=pos.y+yoffset})
--   end,
--   price = 1,
-- })

--todo: change/remove?
main.defineCard("redFan", {
  name = "Red Fan",
  description = "Spawns a free card\nwhich gives {priceColor}-6 PRICE",
  image = "redfan",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    main.basicSpawnCard("subtract", {temporary = 1, energy=0}, ent, "hand")
  end
})

main.defineCard("cell", {
  name = "Cell",
  image = "cell",
  trigger = {"DEPLOY"},
  price = 2,
  spawnNews = "goodNews"
})

main.defineCard("factory", {
  name = "Factory",
  description = "Spawns a USE-1 junk",
  defaultMoneyGain = 1,
  image = "factory",
  trigger = {"DEPLOY"},
  price = 2,
  onActivate = function (ent)
    main.basicSpawnCard("junk", ent, "hand")
  end,
  rarity = "RARE"
})