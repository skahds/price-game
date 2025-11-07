local pipeline = main.getPipeline("main")
local flux = system.getStorage("flux")
local news = {}

function main.createRewardsOptions(rewards, info)
  if info.rewardType == "card" then
    for i, option in ipairs(rewards) do

      local c = main.createCard(option, {}, "reward")
      main.card.updateAllCardPositionBackToOriginalPosition("reward", {x=640, y=280})
    end
  elseif info.rewardType == "news" then
    local space = 600/#rewards
    for i, option in ipairs(rewards) do
      local xOffsetLeft = -(#rewards-1)*(space/2)-32
      local orderOffset = space*(i-1)
      local n = main.spawnEntity(option, {x=640+xOffsetLeft+orderOffset, y=250}, true)
      n.isRelic = true
      n.ui.sx = 2
      n.ui.sy = 2
      table.insert(news, n)
      n.rewardIndex = i
      n.ui.screenSpace = true
      n.screenSpace = true
    end
  end
end

system.on("main:cardClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.ownerShip == "reward" then
    main.transferOwnership(ent, "hand")
  else
    return
  end
  
  for i=#main.card.reward, 1, -1 do
    pipeline:add(0.15, function ()
      local card = main.card.reward[i]
      main.deleteCard(card)
    end)
  end
end)

system.on("main:newsClicked", function (ent, button)
  local chart = system.getStorage("main:chart")
  if button ~= 1 then
    return
  end

  if ent == nil then
    return
  end

  if ent.chartOrder ~= nil then
    return
  end

  if ent.disabledToChose == true then
    return
  end

  local cam = main.getCamera()

  chart:addNews(ent)
  ent.chartOrder = chart:getNewsAmount()
  ent.ui.screenSpace = false
  ent.screenSpace = false
  ent.sx = cam.zoom
  ent.sy = cam.zoom
  flux.to(ent, 0.3, {sx=1, sy=1})
  ent.ui.sx = 1
  ent.ui.sy = 1
  ent.x, ent.y = main.screenSpaceToWorldPosition(ent.x, ent.y)
  ent.ui.x, ent.ui.y = ent.x, ent.y

  local targx=love.math.random(-50, 50)
  local targy=love.math.random(-50, 50)
  local gridX, gridY = main.grid.toGrid(targx, targy)
  local _, _, width, height = main.grid.entityToGrid(ent)
  local targGridx, targGridy = main.grid.getClosestAvailableGrid(gridX, gridY, width, height, 10)
  targx, targy = main.grid.gridToPos(targGridx, targGridy)

  flux.to(ent, 0.3, {x=targx, y=targy})
  flux.to(ent.ui, 0.3, {x=targx, y=targy})
  table.remove(news, ent.rewardIndex)
  ent.rewardIndex = nil

  for i=#news, 1, -1 do
    local e = news[i]
    e.disabledToChose = true
    flux.to(e.ui, 1, {y=-100}):ease("backin")
    main.wait(1.2, function ()
      e.ui:delete()
      e:delete()
    end)
  end

  news = {}
end)

system.on("@draw", function ()
  if #main.card.reward > 0 or #news > 0 then
    local t = main.printRichText({
      x=0,
      y=100,
      format = "Pick a reward!"
    })
    t.x = 640-t.richText:getWidth()/2
  end
end)

system.on("@update", function ()
  if #news > 0 then
    system.updateStorage("main:isThereNewsReward", true)
  else
    system.updateStorage("main:isThereNewsReward", false)
  end
end)