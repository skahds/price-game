main.defineCard("bounceSpawner", {
  name = "bounce Card",
  image = "volatilityCard",
  trigger = {"POST"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos(-1)
    if pos == nil then
      return
    end
    local yoffset = -pos.direction * 32 + love.math.random(-20, 20)
    main.spawnNews("bouncer", {x=pos.x, y=pos.y+yoffset})
  end,
  price = 1,
})