function system.getFont(id)
  if system.fonts[id] == nil then
    error("font " .. id .. " does not exist")
  end
  return system.fonts[id]
end