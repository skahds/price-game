main.defineCard("bounceSpawner", {
  name = "bounce Card",
  image = "bounceCard",
  description = "test\nwith \\n",
  trigger = {"POST"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()

    if pos == nil then
      return
    end

    local yoffset
    if pos.direction == 1 then
      yoffset = pos.height - love.math.random(0, 60)
    else
      yoffset = -love.math.random(0, 60)
    end
    local xoffset = pos.width
    main.spawnNews("bouncer", {x=pos.x+xoffset, y=pos.y+yoffset})
  end,
  price = 1,
})

main.defineCard("cell", {
  name = "Cell",
  image = "cell",
  trigger = {"POST"},
  price = 2,
  onActivate = function (ent)
    main.createCardBesidesEntInHand("add", {}, ent)
  end
})