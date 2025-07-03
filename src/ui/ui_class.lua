function main.ui.defineUI(id, eType)
  local ent = class()

  function ent:init(args)
    for k, v in pairs(args) do
      if type(k) == "table" then
        self[k] = utils.deepCopy(v)
      else
        self[k] = v
      end
    end

    for k, v in pairs(eType) do
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
    self.cameraFixed = true
    self.tag = self.tag or {}
    self.renderLayer = self.renderLayer or 100
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
        love.graphics.draw(image, self.x, self.y)
      else
        love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
      end

    end, self.cameraFixed)

    if self.onDraw then
      self:onDraw()
    end
  end


  function ent:delete()
    local isIn = false
    for _, ent in pairs(main.ui.deleteQueue) do
      if ent.index == main.ui.deleteQueue then
        isIn = true
      end
    end
    
    if isIn == false then
      table.insert(main.ui.deleteQueue, self)
    end
  end

  main.ui.entities[id] = ent
end