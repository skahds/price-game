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

main.addDescriptionType(59, function (ent)
  if main.canTrigger(ent, "POST") then
    return "{triggerColor}POST{/triggerColor}: On turn starts"
  end
end)

main.addDescriptionType(59, function (ent)
  if main.canTrigger(ent, "DEPLOY") then
    return "{triggerColor}DEPLOY{/triggerColor}: On release"
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
    return "Relic:\nStays in hand"
  end
end)

main.addDescriptionTag(30, function (ent)
  if ent.temporary ~= math.huge then
    local n = ent.temporary
    return "Temporary " .. n ..":\nDeleted after " .. n .. " turn"
  end
end)

main.addDescriptionTag(31, function (ent)
  if ent.repeatActivation > 0 then
    local n = ent.repeatActivation
    return "Repeat " .. n ..":\nRetrigger " .. n .. " times"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultPointGain ~= 0 then
    return "Gives {pointColor}" .. ent.defaultPointGain .. "{/pointColor} points"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMultGain ~= 0 then
    return "Gives {multColor}" .. ent.defaultMultGain .. "X{/multColor} mult"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMoneyGain ~= 0 then
    return "Gives {moneyColor}$" .. ent.defaultMoneyGain .. "{/moneyColor}"
  end
end)

main.addDescriptionType(23, function (ent)
  if ent.isRelic == true then
    return "Hollow: Doesn't take up space"
  end
end)