local font = system.getFont("defaultFont60")
local flux = system.getStorage("flux")
local cover
local restart
local stats = {}


local function deleteAll(args)
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("gameEnd", function ()
  local pipeline = main.getPipeline("main")

  local finalStats = system.getStorage("main:endLevelStats")
  local didWin
  local t = {}
  if system.getStorage("main:gameResult") == "LOSE" then
    table.insert(t, "You have lost!")
    table.insert(t, "You reached cycle " .. (system.getStorage("main:currentCycle") or 1) .. " day " .. (system.getStorage("main:currentRoute") or 1))
    didWin = false
  else
    table.insert(t, "You have won!")
    table.insert(t, "100 {creditIcon} win bonus!")
    didWin=true
  end

  local cycle = system.getStorage("main:currentCycle")
  local day = system.getStorage("main:currentRoute")
  
  local amountCycle = (cycle-1)*50
  if cycle > 1 then
    table.insert(t, "50 {creditIcon} per cleared cycle :" .. amountCycle .." {creditIcon}")
  end

  local amountDay = (day-1)*5
  if day > 1 then
    table.insert(t, "5 {creditIcon} per cleared day: " .. amountDay .. " {creditIcon}")
  end

  local creditMult = main.getTotalCreditsMultilpier()
  table.insert(t, "{creditIcon} multiplier: x" .. math.floor(creditMult*100+0.5)/100 .. " {creditIcon}")

  local total = math.floor((amountDay+amountCycle)*creditMult+0.5)
  if didWin then
    total = total + 100
  end
  table.insert(t, "Total {creditIcon} earned: " .. total .. " {creditIcon}")

  main.meta.giveCredits(total)

  restart = main.ui.spawnUI("settingMenu", {x=540, y=460, renderLayer=102})

  local height = font:getHeight()

  local space = utils.createEvenlySpacedPosition(#t)
  for i, format in ipairs(t) do
    pipeline:add(0.2, function ()
      local t = main.newRichText({
        format = format,
        x=640,
        y=(460-50)/2+50+height*space[i],
        renderLayer=102,
        font=font,
        sx=0.8,
        sy=0.8,
        outline=true,
        outlineColor={0,0,0}
      })
      local ox = t.richText:getWidth()/2
      t.ox = ox
      t.oy = t.richText:getHeight()/2
      table.insert(stats, t)
      flux.to(t, 0.4, {sx=1, sy=1}):ease("backinout")
    end)
  end

  if didWin then
    local amountOfWin = main.meta.getStats("amountOfWin") or 0
    main.meta.updateStats("amountOfWin", amountOfWin+1)
  end


  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end
  system.updateStorage("main:score", 0)
  main.showCharts()

  main.showTopTab()

  if love.filesystem.getInfo("save.sav") then
    love.filesystem.remove("save.sav")
  end
  
  if didWin then
    local runStats = system.getStorage("main:runStats")
    local isModeActive = false
    for k, v in pairs(runStats.modes) do
      if v == true then
        isModeActive = true
      end
    end
    if runStats.achievementID and isModeActive == false then
      main.meta.giveAchievement(runStats.achievementID)
    end
  end

  if Steam then
    Steam.userStats.storeStats()
  end
end, function ()

  main.hideTopTab()

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