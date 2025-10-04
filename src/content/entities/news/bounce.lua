main.defineNews("bouncer", {
  name = "bouncer",
  image = "upNews",
  trigger = {"POST"},
  temporary = 3,
  onActivate = function (ent)
    local bar = system.getStorage("main:currentBar")
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()
    if bar == nil then
      return
    end
    if bar:checkCollide(ent.ui) then
      local change = (bar.startPrice - bar.endPrice)/2
      bar:changePrice(change)
    end
  end,
  onDraw = function ()

  end
})