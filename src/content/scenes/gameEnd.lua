local font = system.getFont("defaultFont60")
local cover
local restart
local stats = {}


local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("gameEnd", function ()
  local pipeline = main.getPipeline("main")

  local finalStats = system.getStorage("main:endLevelStats")
  local t = {}
  if system.getStorage("main:gameResult") == "LOSE" then
    table.insert(t, "You have lost!")
  else
    table.insert(t, "You have won!")
    table.insert(t, "Thanks for playing")
  end
  
  table.insert(t, "Total score: " .. finalStats.finalScore)

  main.ui.spawnUI("settingRestart", {x=540, y=350})

  local height = font:getHeight()

  for i, format in ipairs(t) do
    pipeline:add(0.2, function ()
      table.insert(stats, main.newRichText({
        format = format,
        x=500,
        y=200+height*(i-1),
      }))
    end)
  end

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end
  system.updateStorage("main:score", 0)
end, function ()

  deleteAll({cover, restart})
  deleteAll(stats)
end)