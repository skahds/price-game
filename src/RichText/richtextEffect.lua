local RichText = system.getStorage("RichText")

RichText.addEffect("img", function(self, args, info)
  if self.richTextTable == nil then
    return
  end

  local image = system.getImage(args.i)
  local t = self.richTextTable
  local defaultFont = system.getStorage("defaultFont")
  local fontFactor = 0.5+t.richText.font:getWidth(t.format)/defaultFont:getWidth(t.format)/2

  -- make it scale :)
  local scale = 27/math.min(image:getHeight(), image:getHeight())
  system.render(t.renderLayer+1, function ()
    love.graphics.draw(image,
    t.x+info.x*fontFactor*(t.sx or 1),
    t.y+self:getHeight()*7/9, 0,
    (t.sx or 1)*scale,
    (t.sy or 1)*scale,
    0,
    image:getHeight())
  end, t.screenSpace)

  self:setColor(1, 1, 1, 0)
end)

RichText.addEffect("c", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 1
  local b = args.b or 1
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("energyColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.7
  local b = args.b or 0.3
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("moneyColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.8
  local b = args.b or 0
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("priceColor", function (self, args, info)
  local r = args.r or 0.3
  local g = args.g or 0.7
  local b = args.b or 1
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("multColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.7
  local b = args.b or 0.97
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("triggerColor", function(self, args, info)
  local r = args.r or 0.97
  local g = args.g or 0.71
  local b = args.b or 0.4
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("repeatColor", function(self, args, info)
  local r = args.r or 0.8
  local g = args.g or 0.38
  local b = args.b or 0.48
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("commonColor", function(self, args, info)
  local r = args.r or 0.8
  local g = args.g or 0.8
  local b = args.b or 0.8
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("rareColor", function(self, args, info)
  local r = args.r or 0.6
  local g = args.g or 0.9
  local b = args.b or 1
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("epicColor", function(self, args, info)
  local r = args.r or 0.8
  local g = args.g or 0.4
  local b = args.b or 0.8
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("greenColor", function(self, args, info)
  local r = args.r or 0.3
  local g = args.g or 0.9
  local b = args.b or 0.3
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("brightGreenColor", function(self, args, info)
  local r = args.r or 0.4
  local g = args.g or 1
  local b = args.b or 0.4
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("redColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.3
  local b = args.b or 0.3
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("brightRedColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.6
  local b = args.b or 0.6
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)