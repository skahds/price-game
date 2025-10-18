main.entities = {}

main.entities.basicEnt = class()
local basicEnt = main.entities.basicEnt

function basicEnt:init(args)
  for k, v in pairs(args) do
    if type(k) == "table" then
      self[k] = utils.deepCopy(v)
    else
      self[k] = v
    end
  end

  self.x = self.x or 0
  self.y = self.y or 0
  self.width = self.width or self.defaultWidth or 0
  self.height = self.height or self.defaultHeight or 0
  self.r = 0
  self.sx = 1
  self.sy = 1
  self.ox = 0
  self.oy = 0
  self.screenSpace = self.screenSpace or false
  self.renderLayer = self.renderLayer or 1
  self.isVisible = self.isVisible or true
end

function basicEnt:draw()
  if self.ui then
    -- this ent has a specialized ui which handles its appearance
    return
  end

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

    else
      love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    end
  end, self.screenSpace)

  if self.onDraw then
    self:onDraw()
  end
end

function basicEnt:delete()
  if self.isAboutToBeDeleted ~= true then
    self.isAboutToBeDeleted = true
    table.insert(main.deleteQueue, self)
    system.call("main:entityDeleted", self)
  end
end