main.runModifiers = {}

function main.defineModifiers(content)
  content.amount = 0
  table.insert(main.runModifiers, content)
end


function main.getTotalModifierEffect()
  local totalValue = 1
  local modifierValues = system.getStorage("main:modifierValues")
  for i, value in pairs(modifierValues) do
    totalValue = totalValue * (1 - value * main.runModifiers[i].scoreEffect/100)
  end
  return totalValue
end