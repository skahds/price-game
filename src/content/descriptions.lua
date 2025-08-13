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
  if ent.price then
    return "{moneyColor}$" .. ent.price .. "{/moneyColor}"
  end
end)

main.addDescriptionTag(10, function (ent)
  if ent.trigger then
    return "PRE:\nActivates before\nBar spawns."
  end
end)

main.addDescriptionTag(20, function (ent)
  return "Other tag!"
end)

main.addDescriptionTag(30, function (ent)
  return "And another tag or something!"
end)