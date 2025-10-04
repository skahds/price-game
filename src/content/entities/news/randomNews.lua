main.defineNews("goodNews", {
  name = "Good thing",
  image = "upNews",
  trigger = {"POST"},
  temporary = 3,
  defaultPointGain=3,
})

main.defineNews("badNews", {
  name = "Bad thing",
  image = "downNews",
  trigger = {"POST"},
  temporary = 3,
  defaultPointGain=-3,
})