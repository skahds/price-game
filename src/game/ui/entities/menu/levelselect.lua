local flux = system.getStorage("flux")

main.ui.defineUI("levelSelect", {
  -- change these when spawned
  name = "Level",
  description = "nothing much here",
  image = "levelSelect",
  text = "1",
  renderLayer = 4,
  moneyReward = 0,
  reward = nil,
  -- showDescription = true,
  width = 64,
  height= 64,
  ox=32,
  oy=32,
  screenSpace = false,
  scoreRequirement = 0,
  targetScene = "play",
  isTweening=false,
  onHover = function (ent)
    if ent.isTweening == false then
      ent.tween = flux.to(ent, 0.3, {sx=2, sy=2}):ease("backinout")
      ent.isTweening=true
    end
  end,
  notHovered = function (ent)
    if ent.isTweening == true then
      ent.tween = flux.to(ent, 0.3, {sx=1, sy=1}):ease("backinout")
      ent.isTweening=false
    end
  end,
  onMouseReleased = function (ent, button)
    local pipeline = main.getPipeline("scene")
    if #pipeline.pipeline == 0 then
      system.updateStorage("main:moneyReward", ent.moneyReward)
      system.updateStorage("main:scoreRequirement", ent.scoreRequirement)
      -- system.updateStorage("main:scoreRequirement", 1)
      main.playScene(ent.targetScene)
      if ent.reward and ent.reward.claim then
        local reward = system.getStorage("main:endLevelReward")
        table.insert(reward, ent.reward)
      end

      if ent.enemy then
        local e = main.spawnNews(ent.enemy.id, {x=0,y=0})
        e.ui.isVisible = false 
      end

      local currentRoute = system.getStorage("main:currentRoute")
      local cycle = system.getStorage("main:currentCycle")
      system.updateStorage("main:currentRoute", currentRoute + 1)
      if currentRoute == #system.getStorage("main:route")[cycle] then
        system.updateStorage("main:currentRoute", 1)
        system.updateStorage("main:currentCycle", cycle + 1)
        system.updateStorage("main:currentDay", 0)
      end
    end
  end,
})