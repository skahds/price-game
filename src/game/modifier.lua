main.runModifiers = {}

function main.defineModifiers(content)
  content.amount = 0
  table.insert(main.runModifiers, content)
end


function main.getTotalModifierEffect()
  local totalValue = 1
  local modifierValues = system.getStorage("main:modifierValues") or {}
  for i, value in pairs(modifierValues) do
    totalValue = totalValue * (1 - value * main.runModifiers[i].scoreEffect/100)
  end
  return totalValue
end

function main.getTotalCreditsMultilpier()
  local totalValue = 1
  local modifierEffect = main.getTotalModifierEffect()
  local difficultyMultiplier = system.getStorage("main:difficultyMultiplier") or 1
  totalValue = modifierEffect * difficultyMultiplier
  return totalValue
end

system.register("modifier", 17, function ()
  local t = {
    modifierValues = system.getStorage("main:modifierValues") or {},
    difficultyMultiplier = system.getStorage("main:difficultyMultiplier") or 1,
  }
  return t
end, function (t)
  system.updateStorage("main:modifierValues", t.modifierValues)
  system.updateStorage("main:difficultyMultiplier", t.difficultyMultiplier)
end)