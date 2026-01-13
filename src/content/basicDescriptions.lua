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

  if main.canTrigger(ent, "ROUND") then
    return "Round starts:"
  end

  if main.canTrigger(ent, "TURNEND") then
    return "Turn ends:"
  end
  if main.canTrigger(ent, "PRICECHANGE") then
    return "{priceColor}PRICE{/priceColor} changes:"
  end
  if main.canTrigger(ent, "EACHTURN") then
    return "Each turn:"
  end
  if main.canTrigger(ent, "CARDTRIGGER") then
    return "Card activates:"
  end
  if main.canTrigger(ent, "ENCOUNTER") then
    return "Encounter begins:"
  end
  if main.canTrigger(ent, "OBTAIN") then
    return "When obtained:"
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
    table.remove(t, 1)
    table.remove(t, #t)
    return utils.combineSlashN(t)
  end
end)

local function combine(str, str2)
  if str == "" then
    return str2
  else
    return str .. " " .. str2
  end
end

main.addDescriptionType(60, function (ent)
  local text = ""
  -- if ent.price then
  --   text = text .. "{moneyColor}$" .. ent.price .. "{/moneyColor} "
  -- end
  if ent.rarity then
    text = combine(text, ent.rarity.format)
  end
  if ent.energy then
    text = combine(text, "{energyColor}" .. ent.energy .. "{/energyColor}{energyIcon}")
  end
  if text ~= "" then
    return text
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultPriceGain ~= 0 then
    return "{priceColor}" .. format(ent.defaultPriceGain) .. " PRICE"
  end
end)

main.addDescriptionType(23, function (ent)
  if ent.defaultMultGain ~= 0 then
    return "{multColor}" .. format(ent.defaultMultGain) .. " MULT"
  end
end)

main.addDescriptionType(24, function (ent)
  if ent.defaultPriceMultiplier and ent.defaultPriceMultiplier ~= 1 then
    return "{priceColor}X" .. ent.defaultPriceMultiplier .. " PRICE"
  end
end)

main.addDescriptionType(25, function (ent)
  if ent.defaultMultMultiplier and ent.defaultMultMultiplier ~= 1 then
    return "{multColor}X" .. ent.defaultMultMultiplier .. " MULT"
  end
end)

main.addDescriptionType(26, function (ent)
  if ent.defaultMoneyGain ~= 0 then
    return "Earn {moneyColor}" .. utils.insertString(format(ent.defaultMoneyGain), 2, "$")
  end
end)

main.addDescriptionType(27, function (ent)
  if ent.defaultEnergyGain ~= 0 then
    return "{energyColor}" .. format(ent.defaultEnergyGain) .. " ENERGY"
  end
end)

main.addDescriptionType(28, function (ent)
  if ent.defaultDrawCard ~= 0 then
    return "Draws " .. ent.defaultDrawCard .. " CARD"
  end
end)

main.addDescriptionType(29, function (ent)
  if ent.isRelic == true then
    if ent.isCard then
      return "Stays in hand"
    end
    if ent.isNews then
      return "Stays between encounters"
    end
  end
end)

main.addDescriptionType(30, function (ent)
  if ent.temporary ~= math.huge then
    local n = ent.temporary
    return "Deleted after " .. n .. " use"
  end
end)

main.addDescriptionType(31, function (ent)
  if ent.momentary then
    return "Deleted after encounter ends"
  end
end)


main.addDescriptionType(32, function (ent)
  if ent.repeatActivation > 0 then
    local n = ent.repeatActivation
    if n == 1 then
      return "{repeatColor}REPEAT-" .. n .."{/repeatColor}: Retrigger " .. n .. " time"
    else
      return "{repeatColor}REPEAT-" .. n .."{/repeatColor}: Retrigger " .. n .. " times"
    end
  end
end)

main.addDescriptionType(33, function (ent)
  if ent.isHollow == true then
    return "HOLLOW: Doesn't take up space"
  end
end)



main.addDescriptionTag(30, function (ent)
  if ent.descriptionTagEntity then
    local def = main.entities[ent.descriptionTagEntity].definition
    local t = main.parseDescriptionList(main.getEntityDefinitionWithComponents(def))
    table.remove(t, #t)

    if def.isCard then
      t[1] = t[1] .. " " .. "{energyColor}{energyIcon}" .. (def.energy or 1)
    end

    local result = utils.combineSlashN(t)
    return result
  end
end)