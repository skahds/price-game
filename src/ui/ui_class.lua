function main.ui.defineUI(id, eType)
  local ent = class()
  ent.id = id

  function ent:init(args)
    for k, v in pairs(eType) do
      if type(v) == "table" then
        self[k] = utils.deepCopy(v)
      else
        self[k] = v
      end
    end

    for k, v in pairs(args) do
      -- if type(v) == "table" then
        -- self[k] = utils.deepCopy(v)
      -- else
        --something to do with parents n stuff
        self[k] = v
      -- end
    end

    self.isUI = true
    self.x = self.x or 0
    self.y = self.y or 0
    self.width = self.width or self.defaultWidth or 0
    self.height = self.height or self.defaultHeight or 0
    self.overrideHitbox = self.overrideHitbox -- if size changes, update this too explicitly
    self.r = self.r or 0
    self.sx = self.sx or 1
    self.sy = self.sy or 1
    self.ox = self.ox or 0
    self.oy = self.oy or 0
    self.rx = self.rx or 0
    self.ry = self.ry or 0
    if self.screenSpace == nil then
      self.screenSpace = true
    end
    self.isVisible = true
    self.drawDefaultRectangle = true
    self.renderLayer = self.renderLayer or 100
  end

  function ent:update()
    if self.onUpdate then
      self:onUpdate()
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

      if self.shader then
        local shader = system.getShader(self.shader.shader)
        for k, v in pairs(self.shader) do
          if k ~= "shader" then
            shader:send(k, v)
          end
        end
        love.graphics.setShader()
      end
      
      local x = system.ask("ui:getUIX", combiner.ADD, self)
      local y = system.ask("ui:getUIY", combiner.ADD, self)
      
      if self.image then
        local image = system.getImage(self.image)
        love.graphics.draw(image, x, y, self.r, self.sx, self.sy, self.ox, self.oy)
      elseif self.drawDefaultRectangle then
        love.graphics.rectangle("fill", x-self.ox*self.sx, y-self.oy*self.sy, self.width, self.height, self.rx, self.ry)
      end

    end, self.screenSpace)

    if self.onDraw then
      self:onDraw()
    end
  end

  function ent:getX()
    return self.x - self.ox * self.sx
  end

  function ent:getY()
    return self.y - self.oy * self.sy
  end

  function ent:getWidth()
    return self.width * (self.sx or 1)
  end
  
  function ent:getHeight()
    return self.height * (self.sy or 1)
  end


  function ent:delete()
    if self.isAboutToBeDeleted ~= true then
      self.isAboutToBeDeleted = true
      table.insert(main.ui.deleteQueue, self)
      system.call("ui:entityDeleted", self)
    end
  end

  main.ui.entities[id] = ent
end

system.answer("ui:getUIX", function (ent)
  return ent.x
end)

system.answer("ui:getUIY", function (ent)
  return ent.y
end)