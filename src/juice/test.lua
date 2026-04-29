-- local flux = system.getStorage("flux")
-- local t = main.newRichText({
--   x=30,
--   y=120,
--   screenSpace=true,
--   renderLayer=300,
--   sx=1,
--   sy=1,
--   ox=-100,
--   oy=-100,
--   format = "inline images {creditIcon} aaa"
-- })
-- flux.to(t, 5, {sx=2, sy=2,ox=-500, oy=-200})

-- local t = main.newRichText({
--   x=30,
--   y=170,
--   screenSpace=true,
--   renderLayer=300,
--   font=system.getFont("defaultFont40"),
--   format = "this {points} and that {mult}"
-- })

-- local function setup(x, y)
--   local xP, yP = main.grid.gridToPos(x, y)
--   return {x=xP, y=yP}
-- end

-- local pipeline = 
-- system.on("@keyreleased", function (key)
--   if key ~= "k" then
--     return
--   end

--   local cards = {}
--   for i, ent in pairs(main.entities) do
--     if ent and ent.definition and ent.definition.isCard and love.math.random() > 0.3 then
--       table.insert(cards, i)
--     end
--   end

--   for i, card in ipairs(cards) do
--     main.createCard(card, {}, "hand")
--   end


--   -- -- main.spawnNews("goodNews", setup(2, 3))

--   -- local chart = system.getStorage("main:chart")
--   -- local bars = {
--   --   170,
--   --   -230
--   --   -10,---50
--   --   90,
--   --   -50,
--   --   -10,
--   --   45,
--   --   -50,
--   --   -20,
--   --   165,
--   --   -110,
--   --   -15,
--   --   100,
--   --   -60,
--   --   -20,
--   --   90,
--   --   -30,
--   --   -10,
--   --   -70,
--   --   50,
--   --   -75,
--   --   180,
--   --   15,
--   --   -210,
--   --   240
--   -- }
--   -- for i, bar in ipairs(bars) do
--   --   local difference = love.math.random()
--   --   main.addPrice(bar+bar*difference)
--   --   main.spawnBar()
--   --   main.addPrice(bar)
--   --   main.spawnBar()
--   --   main.addPrice(bar-bar*difference)
--   --   main.spawnBar()
--   -- end
  
-- end)