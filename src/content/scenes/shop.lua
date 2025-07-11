local cover
local buyBox

local function deleteAll(args)
  for k, ent in pairs(args) do
    if ent.delete then
      ent:delete()
    end
  end
end

main.defineScene("shop", function ()
  cover = main.ui.spawnUI("cover", {x=50, y=-20, width=400, height=1500,
    color = {0.5, 0.5, 0.5},
    outlineColor = {0.4, 0.4, 0.4}, outline=20}, true)
  buyBox = main.ui.spawnUI("buyBox", {x=800, y= 232}, true)
  system.updateStorage("shop:buyBox", buyBox)

  local bag = system.getStorage("rarity:bag")
  for i=1, 5 do
    local card = bag:getRandomCard()
    main.createCard(card, {}, "shop")
  end

  main.card.updateAllCardPositionBackToOriginalPosition("shop", {x=640, y=100})
end, function ()

  deleteAll({cover, buyBox})
end)