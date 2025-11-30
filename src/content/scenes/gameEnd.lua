local font = system.getFont("defaultFont60")
local flux = system.getStorage("flux")
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

  main.ui.spawnUI("settingRestart", {x=540, y=400})

  local height = font:getHeight()

  for i, format in ipairs(t) do
    pipeline:add(0.2, function ()
      local t = main.newRichText({
        format = format,
        x=640,
        y=200+height*(i-1),
        renderLayer=102,
        font=font,
        sx=0.8,
        sy=0.8,
      })
      local ox = t.richText:getWidth()/2
      t.ox = ox
      table.insert(stats, t)
      flux.to(t, 0.4, {sx=1, sy=1}):ease("backinout")
    end)
  end

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end
  system.updateStorage("main:score", 0)
  main.showCharts()
end, function ()

  deleteAll({cover, restart})
  deleteAll(stats)
end)