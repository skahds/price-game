main.defineParticle("orb", {
  width=16,
  height=16,
  image="particleOrb",
  renderLayer= 210,
  screenSpace=true,
})

local function createJuice(amount, color, targetState)
  local chart = system.getStorage("main:chart")
  local pricePos = chart:getCurrentPricePos()
  local posX, posY = main.worldPositionToScreenSpace(pricePos.x, pricePos.y)
  local cam = main.getCamera()

  for i=1, amount do
    local time = love.math.random(50, 70)/100
    local scale = love.math.random(15, 25)/10
    
    local c = utils.deepCopy(color)
    c[1] = c[1] + love.math.random(90, 110)/100 -1
    c[2] = c[2] + love.math.random(90, 110)/100 -1
    c[3] = c[3] + love.math.random(90, 110)/100 -1

    main.spawnParticle("orb", {
      color=c,
      x=posX+love.math.random(100, -100)+pricePos.width/2*cam.zoom,
      y=posY+love.math.random(100, -100),
      targetState=targetState,
      timeToTravel=time,
      lifetime=time,
      sx=scale,
      sy=scale
    })
  end
end

system.on("main:currentPriceChanged", function (change)
  local color
  if change > 0 then
    color={0.5, 0.9, 0.5}
  else
    color={0.9, 0.5, 0.5}
  end
  local amount = math.floor(math.log(math.abs(change)*2)+0.5)+3
  createJuice(amount, color, {x=50+350/4, y=300})
end)

system.on("main:multChanged", function (change)
  local color
  if change > 0 then
    color = {1, 0.8, 1}
  else
    color = {1, 0.6, 0.7}
  end

  local amount = math.floor(math.log(math.abs(change)*2)+0.5)+3
  createJuice(amount, color, {x=50+350*3/4, y=300})
end)