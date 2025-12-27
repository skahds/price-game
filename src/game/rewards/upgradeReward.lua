local flux = system.getStorage("flux")
local existingUI = {}
local y = 640*2/5
local cardSelected
local currentUpgrade

local upgrades = {
  {
    description = "Card costs {energyColor}-1 {energyIcon}ENERGY",
    filter = function (card)
      if card.energy ~= 0 then
        return true
      end
    end,
    upgrade = function (card)
      card.energy = card.energy - 1
      card.overrideEnergy = card.energy
    end
  }, {
    description = "Card generates {moneyColor}$1",
    upgrade = function (card)
      card.defaultMoneyGain = card.defaultMoneyGain + 1
    end
  }, {
    description = "Card gains {multColor}+4 {multIcon}MULT",
    upgrade = function (card)
      card.defaultMultGain = card.defaultMultGain + 4
    end
  }, {
    description = "Card gains {priceColor}+30 {priceIcon}PRICE",
    upgrade = function (card)
      card.defaultPriceGain = card.defaultPriceGain + 30
    end
  }, {
    description = "Card gains {priceColor}-30 {priceIcon}PRICE",
    upgrade = function (card)
      card.defaultPriceGain = card.defaultPriceGain - 30
    end
  },
}

local function setRandomCardForUpgrade()
  currentUpgrade = upgrades[love.math.random(1, #upgrades)]

  local card = main.getRandomCard(function (card)
    if card.temporary == 1 then
      return false
    else
      if not currentUpgrade.filter or currentUpgrade.filter(card) then
        return true
      else
        return false
      end
    end
  end)
  if card == nil then card = main.getRandomCard() end
  if card == nil then return end

  main.transferOwnership(card, "upgrade")
  cardSelected = card
end

function main.createRewardsUpgrade()
  currentUpgrade = nil
  table.insert(existingUI, main.ui.spawnUI("rerollUpgrade", {
    x=640-350-125,
    y=y-50,
  }))

  table.insert(existingUI, main.ui.spawnUI("applyUpgrade", {
    x=640+350-125,
    y=y-50,
  }))

  setRandomCardForUpgrade()
end

function main.clearRewardUpgrade()
  currentUpgrade = nil
  if cardSelected and cardSelected.isAboutToBeDeleted ~= true then
    main.transferOwnership(cardSelected, "hand")
  end
  cardSelected = nil
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

  local t = main.printRichText({
    format = "{moneyColor}$" .. main.getMoney(),
      x=640-350,
      y=y+100,
      renderLayer = 140,
      font = system.getFont("defaultFont80"),
      outline = true
    })
  t.x = t.x - t.richText:getWidth()/2

  if currentUpgrade then
    local t = main.printRichText({
      format = currentUpgrade.description,
      x=640,
      y=50,
      renderLayer = 140,
    })
    t.x = t.x - t.richText:getWidth()/2
  end
end)

local function reroll()
  local card = cardSelected
  main.transferOwnership(card, "hand")
  setRandomCardForUpgrade()
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
    if cardSelected == nil then return end
    if main.getMoney() > ent.cost then
      main.addMoney(-ent.cost)
    else
      return
    end

    ent.cost = ent.cost + 1
    main.updateRichTextText(ent.richtext, "Reroll {moneyColor}$" .. ent.cost .. "{/moneyColor}")
    reroll()
  end
})

main.ui.defineButton("applyUpgrade", {
  width = 250,
  height = 100,
  color = {0.4, 0.4, 0.7},
  renderLayer = 130,
  screenSpace = true,
  cost = 5,
  text = "Apply",
  audio = "breaker",
  onButtonClicked = function (ent)
    if cardSelected == nil then
      return
    end
    currentUpgrade.upgrade(cardSelected)
    main.clearRewardUpgrade()
    main.card.updateAllCardPositionBackToOriginalPosition()
  end
})