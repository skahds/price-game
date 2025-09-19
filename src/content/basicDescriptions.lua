main.addDescriptionType(10, function (ent)
  if ent.name then
    return "   " .. ent.name .. "   "
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

main.addDescriptionTag(11, function (ent)
  if main.canTrigger(ent, "POST") then
    return "POST:\nActivates when turn starts."
  end
end)

main.addDescriptionTag(12, function (ent)
  if main.canTrigger(ent, "POST") then
    return "DEPLOY:\nCan be instantly activated."
  end
end)

main.addDescriptionTag(30, function (ent)
  if ent.temporary then
    local n = ent.temporary
    return "Temporary " .. n ..":\nDeleted after " .. n .. " turn"
  end
end)

main.addDescriptionTag(31, function (ent)
  if ent.repeatActivation then
    local n = ent.repeatActivation
    return "Repeat " .. n ..":\nRetrigger " .. n .. " times"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultPointGain then
    return "Gains {pointColor}" .. ent.defaultPointGain .. "{/pointColor} points"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMultGain then
    return "Gains {multColor}" .. ent.defaultMultGain .. "X{/multColor} mult"
  end
end)

main.addDescriptionType(22, function (ent)
  if ent.defaultMoneyGain then
    return "Gains {moneyColor}$" .. ent.defaultPointGain .. "{/moneyColor}"
  end
end)