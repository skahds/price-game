main.defineNews("goodNews", {
  name = "Good thing",
  image = "bouncer",
  trigger = {"POST"},
  temporary = 3,
  onActivate = function (ent)
    main.addPoint(3)
  end,
})

main.defineNews("badNews", {
  name = "Bad thing",
  image = "bouncer",
  trigger = {"POST"},
  temporary = 3,
  onActivate = function (ent)
    main.addPoint(-3)
  end,
})