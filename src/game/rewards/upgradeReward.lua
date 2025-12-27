local flux = system.getStorage("flux")
local existingUI = {}
local y = 640*2/5
local cardSelected

function main.createRewardsUpgrade()
  table.insert(existingUI, main.ui.spawnUI("rerollUpgrade", {
    x=640-350-125,
    y=y-50,
  }))

  table.insert(existingUI, main.ui.spawnUI("augmentUpgrade", {
    x=640+350-125,
    y=y-50,
  }))

  local card = main.getRandomCard(function (card)
    if card.temporary == 1 then
      return false
    else
      return true
    end
  end)
  if card == nil then card = main.getRandomCard() end
  if card == nil then return end

  main.transferOwnership(card, "upgrade")
  cardSelected = card
end

function main.clearRewardUpgrade()
  if cardSelected and cardSelected.isAboutToBeDeleted ~= true then
    main.transferOwnership(cardSelected, "hand")
  end
  for i, ui in ipairs(existingUI) do
    ui:delete()
  end
end

system.on("@update", function ()
  if cardSelected == nil then
    return
  end
  local ui = cardSelected.ui

  flux.to(ui, 0.3, {
    x=640-ui:getWidth()/2,
    y=y-ui:getHeight()/2
  })
  main.card.updateAllCardPositionBackToOriginalPosition()
end)

local function reroll()
  
end

main.ui.defineButton("rerollUpgrade", {
  width = 250,
  height = 100,
  color = {0.4, 0.7, 0.4},
  renderLayer = 130,
  screenSpace = true,
  cost = 2,
  text = "Reroll {moneyColor}$2{/moneyColor}",
  audio = "breaker",
  onButtonClicked = function (ent)
    if main.getMoney() > ent.cost then
      main.addMoney(-ent.cost)
    else
      return
    end

    ent.cost = ent.cost + 1
    main.updateRichTextText(ent.richtext, "Reroll {moneyColor}$" .. ent.cost .. "{/moneyColor}")
  end
})

main.ui.defineButton("augmentUpgrade", {
  width = 250,
  height = 100,
  color = {0.4, 0.4, 0.7},
  renderLayer = 130,
  screenSpace = true,
  cost = 5,
  text = "Augment",
  audio = "breaker",
  onButtonClicked = function (ent)

  end
})