local font = system.getFont("defaultFont60")
local cover
local continueToShop
local stats = {}


local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("levelEnd", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20}, true)
  continueToShop = main.ui.spawnUI("continueToShop", {x=70, y=100}, true)

  local finalStats = system.getStorage("main:endLevelStats")
  local t = {}
  table.insert(t, "Total point: " .. finalStats.finalPoint)
  table.insert(t, "Turn played: " .. finalStats.barsTaken)

  local height = font:getHeight()

  for i, format in ipairs(t) do
    table.insert(stats, main.newRichText({
      format = format,
      x=500,
      y=200+height*(i-1),
    }))
  end

  while #main.card.draw + #main.card.discard > 0 do
    main.drawCard()
  end
end, function ()

  deleteAll({cover, continueToShop})
  deleteAll(stats)
end)