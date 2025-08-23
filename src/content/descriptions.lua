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
  if ent.price then
    return "{moneyColor}$" .. ent.price .. "{/moneyColor}"
  end
end)

main.addDescriptionTag(10, function (ent)
  if main.canTrigger(ent, "PRE") then
    return "PRE:\nActivates before\nBar spawns."
  end
end)

main.addDescriptionTag(11, function (ent)
  if main.canTrigger(ent, "POST") then
    return "POST:\nActivates after\nBar spawns."
  end
end)

-- main.addDescriptionTag(20, function (ent)
--   return "1234567890-+"
-- end)

main.addDescriptionTag(30, function (ent)
  if ent.temporary then
    local n = ent.temporary
    return "Temporary " .. n ..":\nDeleted after " .. n .. " turn"
  end
end)