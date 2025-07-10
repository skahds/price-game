system.on("main:cardReleased", function (uiEnt)
  if uiEnt.x > 600 then
    main.transferOwnership(uiEnt.card, "ownedCards")
  end
end)