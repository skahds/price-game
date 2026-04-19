local flux = system.getStorage("flux")
local font = system.getFont("defaultFont60")
local continue

local function deleteAll(args)
  if args == nil then return end
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
  end
end

local function continueAction()
  local pipeline = main.getPipeline("main")
  if #pipeline.pipeline > 0 then
    return
  end

  if #main.card.reward > 0 then
    main.clearRewardOptions()
  end

  if system.getStorage("main:isThereNewsReward") then
    main.clearRewardOptions()
  end

  main.clearRewardUpgrade()
  main.clearRewardEditPattern()

  local pipeline = main.getPipeline("scene")
  if #pipeline.pipeline == 0 then
    main.playScene("levelSelect")
  end
end

main.defineScene("treasureRoom", function ()
  local bag = system.getStorage("rarity:bag")
  local t = bag:getRandomNewsWithInfo({amount=3})
  main.createRewardsOptions(t, {rewardType="news"})
  
  main.shuffleDiscardToDraw()
  while #main.card.draw > 0 do
    main.drawCard()
  end

  local pipeline = main.getPipeline("main")
  main.card.updateAllCardPositionBackToOriginalPosition()
  main.showCharts()
  continue = main.ui.spawnUI("treasureRoomContinue", {x=640-150, y=430})

  main.showTopTab()
end, function ()
  main.hideTopTab()
  
  for i=#main.card.hand, 1, -1 do
    local card = main.card.hand[i]
    main.addCardToDraw(card)
  end

  deleteAll({continue})

  main.incrementDay()
end)

main.ui.defineButton("treasureRoomContinue", {
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

system.on("@draw", function ()

  if system.getStorage("main:currentScene") ~= "treasureRoom" then
    return
  end

  if continue and (#main.card.reward > 0 or system.getStorage("main:isThereNewsReward")) then
    main.updateRichTextText(continue.richtext, "Skip")
  else
    main.updateRichTextText(continue.richtext, "Continue")
  end

  system.render(101, function ()
    love.graphics.setColor(0.08, 0.08, 0.08, 0.6)
    love.graphics.rectangle("fill", 0, 0, 1280, 720)
  end, true)
end)