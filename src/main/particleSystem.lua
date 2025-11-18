main.particle = {
  world = {},
  delete={},
  particles={}
}

local flux = system.getStorage("flux")

function main.defineParticle(id, etype)
  local ent = class()
  main.particle.particles[id] = ent
  ent.definition = etype

  function ent:init(args)
    for k, v in pairs(etype) do
      if type(v) == "table" then
        self[k] = utils.deepCopy(v)
      else
        self[k] = v
      end
    end

    for k, v in pairs(args) do
      if type(v) == "table" then
        self[k] = utils.deepCopy(v)
      else
        self[k] = v
      end
    end

    self.x = self.x or 0
    self.y = self.y or 0
    self.width = self.width or self.defaultWidth or 0
    self.height = self.height or self.defaultHeight or 0
    self.r = self.r or 0
    self.sx = self.sx or 1
    self.sy = self.sy or 1
    self.ox = self.ox or self.width/2
    self.oy = self.oy or self.height/2
    self.screenSpace = self.screenSpace or false
    self.renderLayer = self.renderLayer or 100
    self.isVisible = self.isVisible or true

    --particle related stuffs
    self.lifetime = self.lifetime or 1
    self.targetState = self.targetState or nil
    self.timeToTravel = self.timeToTravel or 1
  end

  function ent:update()
    local dt = system.getStorage("dt")
    if self.lifetime then
      if self.lifetime <= 0 then
        self:delete()
      end
      self.lifetime = self.lifetime - dt
    end

    if self.targetState then
      flux.to(self, self.timeToTravel, self.targetState)
      self.timeToTravel = (self.timeToTravel or 1) - dt
    end
  end

  function ent:draw()
    local renderLayer = self.renderLayer
    system.render(renderLayer, function ()

      if self.color then
        love.graphics.setColor(self.color)
      else
        love.graphics.setColor(1, 1, 1)
      end
      
      if self.image then
        local image = system.getImage(self.image)
        love.graphics.draw(image, self.x, self.y, self.r, self.sx, self.sy, self.ox, self.oy)
      end
    end, self.screenSpace)

    if self.onDraw then
      self:onDraw()
    end
  end

  function ent:delete()
    if self.isAboutToBeDeleted ~= true then
      self.isAboutToBeDeleted = true
      table.insert(main.particle.delete, self)
    end
  end
end

function main.spawnParticle(id, args)
if main.particle.particles[id] == nil then
    error("unknown particle " .. id)
  end

  table.insert(main.particle.world, main.particle.particles[id]:new(args))
  local entity =  main.particle.world[#main.particle.world]
  entity.index = #main.particle.world

  return entity
end

system.on("@update", function ()
  for _, ent in pairs(main.particle.world) do
    if ent.update then
      ent:update()
    end
  end

  for i=#main.particle.delete, 1, -1 do
    local ent = main.particle.delete[i]
    local entIndex = ent.index
    if ent.index ~= #main.particle.world then
      local lastEnt = main.particle.world[#main.particle.world]
      main.particle.world[entIndex] = lastEnt
      lastEnt.index = entIndex
    end

    table.remove(main.particle.world, #main.particle.world)
  end

  main.particle.delete = {}
end)

system.on("@draw", function ()
  for _, ent in pairs(main.particle.world) do
    if ent.draw and ent.isVisible then
      ent:draw()
    end
  end
end)