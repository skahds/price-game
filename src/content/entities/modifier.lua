local function format(n)
  if n >= 0 then
    return "+" .. n
  else
    return n
  end
end

main.defineModifiers({
  description = "{energyColor}+0 MAX {energyIcon}ENERGY",
  range = {-1, 1},
  scoreEffect = 30,
  effect = function (amount)
    system.updateStorage("main:energyPerTurn", system.getStorage("main:energyPerTurn")+amount)
    system.updateStorage("main:energy", system.getStorage("main:energyPerTurn"))
  end,
  updateDescription = function (amount)
    return "{energyColor}" .. format(amount) .. " MAX ENERGY"
  end
})

main.defineModifiers({
  description = "0 hand size",
  range = {-2, 2},
  scoreEffect = 20,
  effect = function (amount)
    system.updateStorage("main:maxCardAmount", system.getStorage("main:maxCardAmount")+amount)
  end,
  updateDescription = function (amount)
    return format(amount) .. " hand size"
  end
})

main.defineModifiers({
  description = "0 turn per day",
  range = {-2, 2},
  scoreEffect = 15,
  effect = function (amount)
    system.updateStorage("main:roundsPerDay", system.getStorage("main:roundsPerDay")+amount)
  end,
  updateDescription = function (amount)
    return format(amount) .. " turn per"
  end
})