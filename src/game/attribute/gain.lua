system.on("main:entityTriggered", function (ent)
  if ent.defaultPointGain then
    main.addPoint(ent.defaultPointGain)
  end
  if ent.defaultMultGain then
    main.addMult(ent.defaultMultGain)
  end
  if ent.defaultMoneyGain then
    main.addMoney(ent.defaultMoneyGain)
  end
end)