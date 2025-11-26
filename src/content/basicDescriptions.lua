local function format(num)
  if num > 0 then
    return "+" .. num
  else
    return num
  end
end

main.addDescriptionType(10, function (ent)
  if ent.name then
    if ent.spawnNews then
      return ent.name .. " - News"
    end
    return ent.name
  end
end)

main.addDescriptionType(19, function (ent)
  if ent.isNews ~= true then
    return
  end

  if main.canTrigger(ent, "TURNEND") then
    return "Turn ends:"
  end
  if main.canTrigger(ent, "PRICECHANGE") then
    return "{priceColor}Price{/priceColor} changes:"
  end
  if main.canTrigger(ent, "EACHTURN") then
    return "Each turn:"
  end
  if main.canTrigger(ent, "CARDTRIGGER") then
    return "Card activates:"
  end
end)

main.addDescriptionType(20, function (ent)
  if ent.description then
    return ent.description
  end
end)

main.addDescriptionType(21, function (ent)
  if ent.spawnNews then
    local t = main.parseDescriptionList(main.getEntityDefinitionWithComponents(main.entities[ent.spawnNews].definition))
    return utils.combineSlashN(t)
  end
end)

main.addDescriptionType(60, function (ent)
  local text = ""
  -- if ent.price then
  --   text = text .. "{moneyColor}$" .. ent.price .. "{/moneyColor} "
  -- end
  if ent.rarity then
    text =  text .. ent.rarity.format
  end
  if text ~= "" then
    return text
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultPriceGain ~= 0 then
    return "Gives {priceColor}" .. format(ent.defaultPriceGain) .. " PRICE"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMultGain ~= 0 then
    return "Gives {multColor}" .. format(ent.defaultMultGain) .. " MULT"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMoneyGain ~= 0 then
    return "Gives {moneyColor}$" .. ent.defaultMoneyGain
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultDrawCard ~= 0 then
    return "Draws " .. ent.defaultDrawCard .. " CARD"
  end
end)

main.addDescriptionType(29, function (ent)
  if ent.isRelic == true then
    if ent.isCard then
      return "Relic: Stays in hand"
    end
    if ent.isNews then
      return "Relic: Stays between encounters"
    end
  end
end)

main.addDescriptionType(30, function (ent)
  if ent.temporary ~= math.huge then
    local n = ent.temporary
    return "USE-" .. n ..": Deleted after " .. n .. " use"
  end
end)

main.addDescriptionType(31, function (ent)
  if ent.repeatActivation > 0 then
    local n = ent.repeatActivation
    if n == 1 then
      return "{repeatColor}REPEAT-" .. n .."{/repeatColor}: Retrigger " .. n .. " time"
    else
      return "{repeatColor}REPEAT-" .. n .."{/repeatColor}: Retrigger " .. n .. " times"
    end
  end
end)

main.addDescriptionType(32, function (ent)
  if ent.isHollow == true then
    return "HOLLOW: Doesn't take up space"
  end
end)



main.addDescriptionTag(30, function (ent)
  if ent.descriptionTagEntity then
    local t = main.parseDescriptionList(main.getEntityDefinitionWithComponents(main.entities[ent.descriptionTagEntity].definition))
    table.insert(t, 1, main.entities[ent.descriptionTagEntity].definition.name)
    return utils.combineSlashN(t)
  end
end)