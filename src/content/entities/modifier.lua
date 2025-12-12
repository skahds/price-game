main.defineModifiers({
  description = "Give {energyColor}+0 MAX ENERGY",
  maxAmount=2,
  effect = function (amount)
    system.updateStorage("main:energyPerTurn", system.getStorage("main:energyPerTurn")+amount)
    system.updateStorage("main:energy", system.getStorage("main:energyPerTurn"))
  end,
  updateDescription = function (amount)
    return "Give {energyColor}+" .. amount .. " MAX ENERGY"
  end
})

main.defineModifiers({
  description = "Increase hand size by 0",
  maxAmount=2,
  effect = function (amount)
    system.updateStorage("main:maxCardAmount", system.getStorage("main:maxCardAmount")+amount)
  end,
  updateDescription = function (amount)
    return "Increase hand size by " .. amount
  end
})