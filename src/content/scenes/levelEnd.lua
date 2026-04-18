system.updateStorage("main:endLevelReward", {})

local flux = system.getStorage("flux")
local font = system.getFont("defaultFont60")
local cover
local levelEndContinue
local objectiveText
local stats = {}

local middleY = 280

main.newPipeline("levelEnd")
local pipeline = main.getPipeline("levelEnd")
pipeline.ignoreGameSpeed = true

local function deleteAll(args)
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end


local function continueAction()
  if #pipeline.pipeline > 0 then
    return
  end
  
  if #stats > 0 then
    for i, text in ipairs(stats) do
      flux.to(text, 0.3, {y=-100})
    end
    main.wait(0.4, function ()
      deleteAll(stats)
    end)
    stats = {}

    if objectiveText and #objectiveText > 0 then
      for i, text in ipairs(objectiveText) do
        flux.to(text, 0.3, {y=text.y-360})
      end
      main.wait(0.4, function ()
        for i, text in ipairs(objectiveText) do
          text:delete()
        end
        objectiveText=nil
      end)
    end
  end

  if #main.card.reward > 0 then
    main.clearRewardOptions()
  end

  if system.getStorage("main:isThereNewsReward") then
    main.clearRewardOptions()
  end

  main.clearRewardUpgrade()
  main.clearRewardEditPattern()

  local reward = system.getStorage("main:endLevelReward")
  if reward ~= nil and #reward > 0 then
    reward[1].claim()
    table.remove(reward, 1)
    return
  end

  local scenePipeline = main.getPipeline("scene")
  if #scenePipeline.pipeline == 0 then
    main.playScene("levelSelect")
  end
end

main.defineScene("levelEnd", function ()
  local reward = system.getStorage("main:endLevelReward")
  levelEndContinue = main.ui.spawnUI("levelEndContinue", {x=640-150, y=430})

  local finalStats = system.getStorage("main:endLevelStats")
  local roundsRemaining = system.getStorage("main:roundsRemaining")
  local t = {}
  table.insert(t, "Total score: " .. finalStats.finalScore)
  table.insert(t, "Turn played: " .. finalStats.barsTaken-1)

  local money = system.getStorage("main:moneyReward")
  table.insert(t, "Money reward: {moneyColor}$" .. money)
  
  local extraMoney = roundsRemaining
  if extraMoney then
    table.insert(t, "{moneyColor}$1{/moneyColor} per turn left: {moneyColor}$" .. extraMoney)
  end
    

  local spawnInfo = {x=1280*1/4}
  local height = font:getHeight()

  local spacing = utils.createEvenlySpacedPosition(#t)
  for i, format in ipairs(t) do
    pipeline:add(0.15, function ()
      local t = main.newRichText({
        format = format,
        x=spawnInfo.x,
        y=middleY+height*(spacing[i]),
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
      -- t.x = t.x - t.richText:getWidth()/2
      flux.to(t, 0.4, {sx=1, sy=1}):ease("backinout")
    end)
  end

  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end

  main.addMoney(money)
  main.addMoney(roundsRemaining)

  if main.objectives.isThereObjectives() then
    objectiveText = main.objectives.createObjectiveRichtext({x=1280*3/4,y=-400,font=system.getFont("defaultFont40"), showProgress=true, renderLayer=105, centerX=true, centerY=true, showForClaim=true})
    local highY, lowY = objectiveText[1].y, objectiveText[#objectiveText].y+objectiveText[#objectiveText].richText:getHeight()
    local middleOfText = highY+((lowY-highY)/2)
    local gapToMiddle = middleY-(middleOfText)
    for i, text in ipairs(objectiveText) do
      text.outline = true
      text.outlineColor = {0,0,0}
      text.sx=0.8
      text.sy=0.8
      pipeline:add(0.15, function ()
        text.y = text.y + gapToMiddle
        flux.to(text, 0.4, {sx=1, sy=1}):ease("backinout")

        if i%2 == 0 then
          main.objectives.claimObjectives()
        end
      end)
    end
  else
    spawnInfo.x = 1280*1/2
  end

  system.updateStorage("main:score", 0)
  system.call("main:scoreChanged", 0)
  main.showCharts()
  main.showTopTab()
end, function ()
  main.hideTopTab()
  
  main.objectives.clearObjectives()

  deleteAll({cover, levelEndContinue})
  deleteAll(stats)
  deleteAll(objectiveText)
  objectiveText = nil

  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    main.addCardToDraw(card)
  end

  main.incrementDay()
end)

main.ui.defineButton("levelEndContinue", {
  width = 300,
  height = 100,
  color = {0.4, 0.4, 0.7},
  renderLayer = 102,
  screenSpace = true,
  text = "Continue",
  audio = "breaker",
  onButtonClicked = function (ent)
    continueAction()
  end
})

system.on("@update", function ()
  if objectiveText then
    main.objectives.updateObjectiveRichtext(objectiveText)
  end
end)

system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "levelEnd" then
    return
  end

  if levelEndContinue and (#main.card.reward > 0 or system.getStorage("main:isThereNewsReward")) then
    main.updateRichTextText(levelEndContinue.richtext, "Skip")
  else
    main.updateRichTextText(levelEndContinue.richtext, "Continue")
  end

  system.render(101, function ()
    love.graphics.setColor(0.08, 0.08, 0.08, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
  end, true)
end)