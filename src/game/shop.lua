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
  local success = true
  local buyBox = system.getStorage("shop:buyBox")
  if buyBox == nil then
    return
  end

  if main.AABB_check(uiEnt, buyBox) and uiEnt.parent.ownerShip == "shop" then
    local price = uiEnt.parent.price or 0
    local money = main.getMoney()
    if money < price then
      success = false
    end
    if success then
      main.addMoney(-price)
      main.addCardToDraw(uiEnt.parent)
    end
  end
  
  main.card.updateAllCardPositionBackToOriginalPosition("shop", {x=640, y=100})
end)

-- system.on("@mouse:released", function (button)
--   if button ~= 1 then
--     return
--   end

--   local success = true
--   local buyBox = system.getStorage("shop:buyBox")
--   local card = system.getStorage("main:currentSelectedCard")
--   local mouse = system.getStorage("realMouse")
--   if buyBox == nil then
--     return
--   end
--   if card == nil then
--     return
--   end
--   print(mouse.x, mouse.y)
--   print(buyBox.x, buyBox.y, buyBox.width, buyBox.height)

--   if main.AABB_check(mouse, buyBox) and card.ownerShip == "shop" then
--     local price = card.price or 0
--     local money = main.getMoney()
--     if money < price then
--       success = false
--     end
--     if success then
--       main.addMoney(-price)
--       main.addCardToDraw(card)
--     end
--   end
  
--   -- main.card.updateAllCardPositionBackToOriginalPosition("shop", {x=640, y=100})
-- end)