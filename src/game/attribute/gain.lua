main.defineComponent("defaultPointGain", 0)
main.defineComponent("defaultMultGain", 0)
main.defineComponent("defaultMoneyGain", 0)

system.on("main:entityTriggered", function (ent)
  if ent.defaultPointGain ~= 0 then
    main.addPoint(ent.defaultPointGain)
  end
  if ent.defaultMultGain ~= 0 then
    main.addMult(ent.defaultMultGain)
  end
  if ent.defaultMoneyGain ~= 0 then
    main.addMoney(ent.defaultMoneyGain)
  end
end)