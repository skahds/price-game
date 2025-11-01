system.updateStorage("main:endLevelReward", {})

local flux = system.getStorage("flux")
local font = system.getFont("defaultFont60")
local cover
local levelEndContinue
local stats = {}

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

local function continueAction()
  local pipeline = main.getPipeline("main")
  if #pipeline.pipeline > 0 then
    return
  end
  
  if #stats > 0 then
    for i, text in ipairs(stats) do
      flux.to(text, 0.3, {y=-100})
    end
    main.wait(0.2, function ()
      deleteAll(stats)
    end)
    stats = {}
  end

  local reward = system.getStorage("main:endLevelReward")
  if reward ~= nil and #reward > 0 then
    reward[1].claim()
    table.remove(reward, 1)
    return
  end

  if #main.card.reward > 0 then
    return
  end

  if system.getStorage("main:isThereNewsReward") then
    return
  end

  local pipeline = main.getPipeline("scene")
  if #pipeline.pipeline == 0 then
    main.playScene("levelSelect")
  end
end

main.defineScene("levelEnd", function ()
  local reward = system.getStorage("main:endLevelReward")
  local pipeline = main.getPipeline("main")
  levelEndContinue = main.ui.spawnUI("levelEndContinue", {x=640-150, y=430}, true)

  local finalStats = system.getStorage("main:endLevelStats")
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local t = {}
  table.insert(t, "Total score: " .. finalStats.finalScore)
  table.insert(t, "Turn played: " .. finalStats.barsTaken)

  local money = roundsRemaining + 3
  if money < 10 then
    local text = "Money Earned: {moneyColor}"
    for i=1, money do
      text = text .. "$"
    end
    table.insert(t, text)
  else
    table.insert(t, "Money Earned: {moneyColor}$" .. money)
  end
    

  local height = font:getHeight()

  for i, format in ipairs(t) do
    pipeline:add(0.2, function ()
      local t = main.newRichText({
        format = format,
        x=640,
        y=200+height*(i-1),
      })
      table.insert(stats, t)
      t.x = t.x - t.richText:getWidth()/2
    end)
  end

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end

  for i=1, money do
    main.addMoney(1)
  end
  system.updateStorage("main:score", 0)

  local chart = system.getStorage("main:chart")
  -- if chart then
  --   chart:forAllNews(function (news)
  --     news.ui.isVisible = false
  --   end)

  --   chart:forAllBar(function (bar)
  --     bar.isVisible = false
  --   end)
  -- end
end, function ()

  deleteAll({cover, levelEndContinue})
  -- deleteAll(stats)

  local chart = system.getStorage("main:chart")
  -- if chart then
  --   chart:forAllNews(function (news)
  --     news.ui.isVisible = true
  --   end)

  --   chart:forAllBar(function (bar)
  --     bar.isVisible = true
  --   end)
  -- end

  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    main.addCardToDraw(card)
  end
end)

main.ui.defineButton("levelEndContinue", {
  width = 300,
  height = 100,
  color = {0.4, 0.4, 0.7},
  renderLayer = 101,
  screenSpace = true,
  text = "Continue",
  audio = "breaker",
  onButtonClicked = function (ent)
    continueAction()
  end
})