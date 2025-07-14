main.shop = {}

function main.tryReroll(price)
  price = price or 0
  
  if main.getMoney() < price then
    return false
  end

  local pipeline = main.getPipeline("main")
  if #pipeline.pipeline > 0 then
    return false
  end

  main.addMoney(-price)

  for i=#main.card.shop, 1, -1 do
    pipeline:add(0.1, function ()
      local card = main.card.shop[i]
      main.deleteCard(card)
    end)
  end

  pipeline:add(0.1, function ()
    main.shop.spawnCards()
  end)

  system.call("shop:reroll")
end

function main.shop.spawnCards()
  local bag = system.getStorage("rarity:bag")
  local shopCardAmount = system.getStorage("shop:maxCardAmount")
  local pipeline = main.getPipeline("main")
  for i=1, shopCardAmount do
    pipeline:add(0.1, function ()
      local card = bag:getRandomCard()
      main.createCard(card, {}, "shop")
      main.card.updateAllCardPositionBackToOriginalPosition("shop", {x=640, y=100})
    end)
  end
end

system.on("main:cardReleased", function (uiEnt)
  local buyBox = system.getStorage("shop:buyBox")
  if buyBox == nil then
    return
  end
  if main.AABB_check(uiEnt, buyBox) and uiEnt.card.ownerShip == "shop" then
    local price = uiEnt.card.price or 0
    local money = main.getMoney()
    if money < price then
      return
    end
    main.addMoney(-price)
    main.transferOwnership(uiEnt.card, "ownedCards")
  end
end)