main.defineNews("bouncer", {
  name = "bouncer",
  image = "bouncer",
  trigger = {"POST"},
  temporary = 3,
  onActivate = function (ent)
    local bar = system.getStorage("main:currentBar")
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()
    if bar == nil then
      return
    end
    print("activateNews")
    if bar:checkCollide(ent.ui) then
      print("collided")
      local change = (bar.startPrice - bar.endPrice)/2
      bar:changePrice(change)
    end
  end,
  onDraw = function ()

  end
})