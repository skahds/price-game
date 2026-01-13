-- todo: add multPrice
main.defineComponent("defaultPriceGain", 0)
main.defineComponent("defaultMultGain", 0)
main.defineComponent("defaultPriceMultiplier", 1)
main.defineComponent("defaultMultMultiplier", 1)
main.defineComponent("defaultMoneyGain", 0)
main.defineComponent("defaultEnergyGain", 0)
main.defineComponent("defaultDrawCard", 0)

system.on("main:entityTriggered", function (ent)
  local pipeline = main.getPipeline("main")

  if ent.defaultPriceGain ~= 0 then
    main.addPrice(ent.defaultPriceGain)
  end
  if ent.defaultMultGain ~= 0 then
    main.addMult(ent.defaultMultGain)
  end
  if ent.defaultPriceMultiplier ~= 1 then
    main.multiplyPrice(ent.defaultPriceMultiplier)
  end
  if ent.defaultMultMultiplier ~= 1 then
    main.multiplyMult(ent.defaultMultMultiplier)
  end
  if ent.defaultMoneyGain ~= 0 then
    main.addMoney(ent.defaultMoneyGain)
  end
  if ent.defaultEnergyGain ~= 0 then
    main.addEnergy(ent.defaultEnergyGain)
  end
  if ent.defaultDrawCard ~= 0 then
    for i=1, ent.defaultDrawCard do      
      pipeline:add(0, function ()
        if main.drawCard() then
          pipeline:insert(0.25, 1, function ()
            
          end)
        end
      end)
    end
  end
end)