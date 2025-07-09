function system.getImage(id)
  if system.sprites[id] == nil then
    error("image " .. id .. " does not exist")
  end
  return system.sprites[id]
end