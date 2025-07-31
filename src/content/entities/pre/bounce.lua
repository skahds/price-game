main.defineCard("bounceSpawner", {
  name = "bounce Card",
  image = "volatilityCard",
  trigger = {"PRE"},
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local bar = chart:getBar(-1)
    if bar == nil then
      print("bar nil")
      return
    end
    main.spawnNews("bouncer", {x=bar.x, y=bar.y})
  end,
  price = 1,
})