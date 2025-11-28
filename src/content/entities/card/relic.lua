-- cards spawns relics, we don't need cards *as* relic anymore
main.defineCard("unit", {
  name = "Unit",
  image = "unit",
  description = "Spawns a relic news\nthat gives {multColor}+2 MULT",
  energy = 0,
  trigger = {"DEPLOY"},
  temporary = 1,
  price = 3,
  onActivate = function (ent)
    local chart = system.getStorage("main:chart")
    local pos = chart:getCurrentPricePos()

    if pos == nil then
      return
    end

    local xoffset = love.math.random(-40, 40)
    local yoffset = love.math.random(-40, 40)
    main.spawnNews("multNews", {x=pos.x+xoffset, y=pos.y+yoffset, isRelic=true})
  end
})