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
  end
  
  table.insert(t, "Total score: " .. finalStats.finalScore)

  restart = main.ui.spawnUI("settingRestart", {x=540, y=400, renderLayer=102})

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

  -- if love.filesystem.getInfo("save.sav") then
  --   love.filesystem.remove("save.sav")
  -- end
end, function ()

  deleteAll({cover, restart})
  deleteAll(stats)
end)

system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "gameEnd" then
    return
  end

  system.render(101, function ()
    love.graphics.setColor(0.08, 0.08, 0.08, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
  end, true)
end)