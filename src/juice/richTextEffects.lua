local RichText = system.getStorage("RichText")

-- RichText.addEffect("basicPulse", function (self, args, info)
--   local speed = 1
--   local scalex, scaley = self:getScale()
  
--   if self.pulseScale then
--     scalex = self.pulseScale[1]
--     scaley = self.pulseScale[2]
--   end
  
--   local dt = system.getStorage("dt")
--   scalex = scalex + dt * speed
--   scaley = scaley + dt * speed
--   self:setScale(scalex, scaley)
--   self.pulseScale = {scalex, scaley}
--   print(scalex, scaley)
-- end)