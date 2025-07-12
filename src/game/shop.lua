main.shop = {}

system.on("shop:reroll", function ()
  local pipeline = main.getPipeline("main")
  if #pipeline.pipeline == 0 then
    for i=#main.card.shop, 1, -1 do
      pipeline:add(0.1, function ()
        local card = main.card.shop[i]
        main.deleteCard(card)
      end)
    end

    pipeline:add(0.1, function ()
      main.shop.spawnCards()
    end)
  end
end)

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
    main.transferOwnership(uiEnt.card, "ownedCards")
  end
end)