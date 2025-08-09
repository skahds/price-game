main.addDescriptionType(function (ent)
  if ent.name then
    return ent.name
  end
end)

main.addDescriptionType(function (ent)
  if ent.description then
    return ent.description
  end
end)

main.addDescriptionType(function (ent)
  if ent.price then
    return "{moneyColor}$" .. ent.price .. "{/moneyColor}"
  end
end)