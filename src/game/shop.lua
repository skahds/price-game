main.shop = {}

function main.tryReroll(price, rerollButton)
  price = price or 0
  
  if main.getMoney() < price then
    return false
  end

  local pipeline = main.getPipeline("main")
  if #pipeline.pipeline > 0 then
    return false
  end

  main.addMoney(-price)
  system.updateStorage("shop:currentRerollPrice", system.getStorage("shop:currentRerollPrice") + 1)
  main.updateRichTextText(rerollButton.richtext, "Reroll {moneyColor}$" .. system.getStorage("shop:currentRerollPrice") .. "{/moneyColor}")

  for i=#main.card.shop, 1, -1 do
    pipeline:add(0.15, function ()
      local card = main.card.shop[i]
      main.deleteCard(card)
    end)
  end

  pipeline:add(0.15, function ()
    main.shop.spawnCards()
  end)

  system.call("shop:reroll")
end

function main.shop.spawnCards()
  local bag = system.getStorage("rarity:bag")
  local shopCardAmount = system.getStorage("shop:maxCardAmount")
  local pipeline = main.getPipeline("main")
  pipeline:add(0.15, function ()
    main.createCard("void", {}, "shop")
    main.card.updateAllCardPositionBackToOriginalPosition("shop", {pos={x=640, y=120}})
  end)
  for i=1, shopCardAmount do
    pipeline:add(0.15, function ()
      local card = bag:getRandomCard()
      main.createCard(card, {}, "shop")
      main.card.updateAllCardPositionBackToOriginalPosition("shop", {pos={x=640, y=120}})
    end)
  end
end

system.on("main:cardClicked", function (ent, button)
  if button ~= 1 then
    return
  end

  local success = true
  -- local ent = system.getStorage("main:currentSelectedCard")

  if ent == nil then
    return
  end

  if ent.ownerShip == "shop" then
    local price = ent.price or 0
    local money = main.getMoney()
    if money < price then
      success = false
    end
    if success then
      main.addMoney(-price)
      main.transferOwnership(ent, "hand")
    end
  end
  
  main.card.updateAllCardPositionBackToOriginalPosition("shop", {pos={x=640, y=120}})
end)

system.on("@draw", function ()
  if system.getStorage("main:currentScene") == "shop" then
    local t = main.printRichText({
      x=640,
      y=10,
      renderLayer=200,
      format = "Left click: buy    Right click: select",
      font=system.getFont("defaultFont50"),
    })
    t.x = t.x - t.richText:getWidth()/2
  end
end)