main.defineComponent("defaultPriceGain", 0)
main.defineComponent("defaultMultGain", 0)
main.defineComponent("defaultMoneyGain", 0)
main.defineComponent("defaultDrawCard", 0)

system.on("main:entityTriggered", function (ent)
  local pipeline = main.getPipeline("main")

  if ent.defaultPriceGain ~= 0 then
    main.addPrice(ent.defaultPriceGain)
  end
  if ent.defaultMultGain ~= 0 then
    main.addMult(ent.defaultMultGain)
  end
  if ent.defaultMoneyGain ~= 0 then
    main.addMoney(ent.defaultMoneyGain)
  end
  if ent.defaultDrawCard ~= 0 then
    for i=1, ent.defaultDrawCard do
      local delay = 0.25
      if i == 1 then
        delay = 0
      end
      pipeline:add(delay, function ()
        main.drawCard()
      end)
    end
  end
end)