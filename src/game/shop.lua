system.on("main:cardReleased", function (uiEnt)
  local buyBox = system.getStorage("shop:buyBox")
  if buyBox == nil then
    return
  end
  if main.AABB_check(uiEnt, buyBox) and uiEnt.card.ownerShip == "shop" then
    main.transferOwnership(uiEnt.card, "ownedCards")
  end
end)