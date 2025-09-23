local RichText = system.getStorage("RichText")

RichText.addEffect("moneyColor", function(self, args, info)
  local r = args.r or 1
  local g = args.g or 0.8
  local b = args.b or 0
  local a = args.a or 1
  self:setColor(r, g, b, a)
end)

RichText.addEffect("pointColor", function (self, args, info)
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
  local r = args.r or 0.87
  local g = args.g or 0.61
  local b = args.b or 0.3
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