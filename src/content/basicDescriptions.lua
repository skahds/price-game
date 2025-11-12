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
    return "Price changes:"
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
    local s = ""
    for i, text in ipairs(t) do
      if i ~= 1 and i ~= #t then
        if i ~= 2 then
          s = s .. "\n".. text
        else
          s = s .. text
        end
      end
    end
    return s
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

main.addDescriptionTag(29, function (ent)
  if ent.isRelic == true then
    if ent.isCard then
      return "Relic\nStays in hand"
    end
    if ent.isNews then
      return "Relic\nStays in chart"
    end
  end
end)

main.addDescriptionTag(30, function (ent)
  if ent.temporary ~= math.huge then
    local n = ent.temporary
    return "Temporary " .. n .."\nDeleted after " .. n .. " use"
  end
end)

main.addDescriptionTag(31, function (ent)
  if ent.repeatActivation > 0 then
    local n = ent.repeatActivation
    return "Repeat " .. n .."\nRetrigger " .. n .. " times"
  end
end)

main.addDescriptionTag(32, function (ent)
  if ent.isHollow == true then
    return "Hollow\nDoesn't take up space"
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