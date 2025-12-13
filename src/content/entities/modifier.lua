local function format(n)
  if n > 0 then
    return "+" .. n
  else
    return n
  end
end

main.defineModifiers({
  description = "Give {energyColor}+0 MAX ENERGY",
  range = {-1, 1},
  effect = function (amount)
    system.updateStorage("main:energyPerTurn", system.getStorage("main:energyPerTurn")+amount)
    system.updateStorage("main:energy", system.getStorage("main:energyPerTurn"))
  end,
  updateDescription = function (amount)
    return "Give {energyColor} " .. format(amount) .. " MAX ENERGY"
  end
})

main.defineModifiers({
  description = "Change hand size by 0",
  range = {-2, 2},
  effect = function (amount)
    system.updateStorage("main:maxCardAmount", system.getStorage("main:maxCardAmount")+amount)
  end,
  updateDescription = function (amount)
    return "Change hand size by " .. format(amount)
  end
})

main.defineModifiers({
  description = "Change turn per day by 0",
  range = {-2, 2},
  effect = function (amount)
    system.updateStorage("main:roundsPerDay", system.getStorage("main:roundsPerDay")+amount)
  end,
  updateDescription = function (amount)
    return "Change turn per day by " .. format(amount)
  end
})