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

main.defineCard("redFan", {
  name = "Red Fan",
  description = "Spawns a temporary card\nwhich gives {pointColor}-5 points",
  image = "redfan",
  trigger = {"ROUND"},
  price = 2,
  onActivate = function (ent)
    main.basicSpawnCard("subtract", {temporary = 1}, ent, "hand")
  end
})

main.defineCard("cell", {
  name = "Cell",
  image = "cell",
  description = "Spawns a news which\ngives {pointColor}+3 points",
  trigger = {"ROUND"},
  price = 2,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()

    if pos == nil then
      return
    end

    local xoffset = love.math.random(-40, 40)
    local yoffset = love.math.random(-40, 40)
    main.spawnNews("goodNews", {x=pos.x+xoffset, y=pos.y+yoffset})
  end
})

main.defineCard("factory", {
  name = "Factory",
  description = "Spawns a temporary-2 junk",
  defaultMoneyGain = 1,
  image = "factory",
  trigger = {"ROUND"},
  price = 2,
  onActivate = function (ent)
    main.basicSpawnCard("junk", {temporary = 2}, ent, "hand")
  end,
  rarity = "RARE"
})