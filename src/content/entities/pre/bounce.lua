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

    local yoffset
    if pos.direction == 1 then
      yoffset = (-pos.height) + love.math.random(40, 60)
    else
      yoffset = love.math.random(40, 60)
    end
    local xoffset = pos.width
    main.spawnNews("bouncer", {x=pos.x+xoffset, y=pos.y+yoffset})
  end,
  price = 1,
})