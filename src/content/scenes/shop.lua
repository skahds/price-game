local cover
local buyBox
local reroll
local continue

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
  buyBox = main.ui.spawnUI("buyBox", {x=1000, y= 400}, true)
  reroll = main.ui.spawnUI("rerollButton", {x=70, y=300}, true)
  continue = main.ui.spawnUI("continueButton", {x=70, y=450}, true)
  system.updateStorage("shop:buyBox", buyBox)
  main.shop.spawnCards()
end, function ()

  deleteAll({cover, buyBox, reroll, continue})
  for i=#main.card.shop, 1, -1 do
    local card = main.card.shop[i]
    main.deleteCard(card)
  end
end)