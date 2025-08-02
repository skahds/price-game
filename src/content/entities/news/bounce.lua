main.defineNews("bouncer", {
  name = "bouncer",
  image = "bouncer",
  trigger = {"POST"},
  onActivate = function (ent)
    local bar = system.getStorage("main:currentBar")
    if bar == nil then
      return
    end
    if bar:checkCollide(ent.ui) then
      local change = bar.startPrice / bar.endPrice
      bar:changePricePIP(change-1)
    end
  end,
  onDraw = function ()

  end
})