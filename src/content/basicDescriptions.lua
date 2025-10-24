local function format(num)
  if num > 0 then
    return "+" .. num
  else
    return num
  end
end

main.addDescriptionType(10, function (ent)
  if ent.name then
    return ent.name
  end
end)

main.addDescriptionType(20, function (ent)
  if ent.description then
    return ent.description
  end
end)

main.addDescriptionType(60, function (ent)
  local text = ""
  if ent.price then
    text = text .. "{moneyColor}$" .. ent.price .. "{/moneyColor} "
  end
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
    return "Temporary " .. n .."\nDeleted after " .. n .. " turn"
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

main.addDescriptionTag(59, function (ent)
  local text = "{triggerColor}TRIGGER{/triggerColor}"
  if main.canTrigger(ent, "ROUND") then
    text = text .. "\n-on turn start"
  end
  if main.canTrigger(ent, "DEPLOY") then
    if ent.isLocked then
      text = text .. "\n-(SHOP-LOCKED)on DEPLOY"
    else
      text = text .. "\n-on DEPLOY"
    end
  end

  if text ~= "{triggerColor}TRIGGER{/triggerColor}" then
    return text
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultPointGain ~= 0 then
    return "Gives {pointColor}" .. format(ent.defaultPointGain) .. " points"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMultGain ~= 0 then
    return "Gives {multColor}" .. format(ent.defaultMultGain) .. " mult"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMoneyGain ~= 0 then
    return "Gives {moneyColor}$" .. ent.defaultMoneyGain
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultDrawCard ~= 0 then
    return "Draws " .. ent.defaultDrawCard .. " card"
  end
end)