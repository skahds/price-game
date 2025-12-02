main.defineParticle("square", {
  width=16,
  height=16,
  image="square_16",
  renderLayer= 210,
  screenSpace=true,
})

local function createJuice(pos, amount, color, renderLayer)
  for i=1, amount do
    local time = love.math.random(75, 80)/100
    local scale = love.math.random(10, 15)/10
    local speed = love.math.random(70, 75)
    
    local c = utils.deepCopy(color)
    c[1] = c[1] + love.math.random(90, 110)/100 -1
    c[2] = c[2] + love.math.random(90, 110)/100 -1
    c[3] = c[3] + love.math.random(90, 110)/100 -1
    c[4] = 0.2

    local randomXdir, randomYdir = utils.randomDirection()

    main.spawnParticle("square", {
      color=c,
      renderLayer=renderLayer-1,
      x=pos.x+love.math.random(10, -10),
      y=pos.y+love.math.random(10, -10),
      direction = {x=randomXdir, y=randomYdir},
      speed = speed,
      lifetime=time,
      sx=scale,
      sy=scale
    })
  end
end

local color = {0.5, 1, 0.3}
system.on("@draw", function ()
  for i, pile in ipairs(main.getAllVisibleStack()) do
    for i, card in ipairs(pile) do
      local ui = card.ui
      if card.overrideEnergy == 0 then
        system.render(ui.renderLayer-1, function ()
          local size=4
          love.graphics.setColor(0.5, 1, 0.3, 0.3)
          love.graphics.rectangle("fill", ui:getX()-size, ui:getY()-size, ui:getWidth()+size*2, ui:getHeight()+size*2, 5, 5)
        end, true)

        if love.math.random() > 0.6 then
          createJuice({x=ui:getX()+ui:getWidth()/2, y=ui:getY()+ui:getHeight()/2}, 1, color, ui.renderLayer)
        end
      end
    end
  end
end)