function main.resetStats()
  system.updateStorage("main:score", 0)
  system.updateStorage("main:mult", 1)
  system.updateStorage("main:energyPerTurn", 3)
  system.updateStorage("main:energy", 3)
  system.updateStorage("main:money", 0)
  system.updateStorage("shop:maxCardAmount", 3)
  system.updateStorage("shop:currentRerollPrice", 0)
  system.updateStorage("main:maxCardAmount", 5)
  system.updateStorage("main:roundsPerDay", 6)
  system.updateStorage("main:roundsRemaining", 6)
  system.updateStorage("main:scoreRequirement", 0)
  system.updateStorage("main:currentRoute", 1)
  system.updateStorage("main:currentCycle", 1)
  system.updateStorage("main:isOnTurn", false)
  system.updateStorage("main:isDoingTutorial", false)
  system.updateStorage("main:tutorialInfos", {stage=1})
end

main.resetStats()

local stats = {"main:score", "main:mult", "main:energyPerTurn", "main:energy", "main:money", "shop:maxCardAmount", "main:maxCardAmount", "main:roundsPerDay", "main:roundsRemaining", "main:scoreRequirement", "main:currentRoute", "main:currentCycle"
}

system.register("stats", 10, function ()
  local t = {}
  for _, v in ipairs(stats) do
    t[v] = system.getStorage(v)
  end
  return t
end, function (t)
  for k, v in pairs(t) do
    system.updateStorage(k, v)
  end
end)


function main.incrementDay()
  local day = "main:currentRoute"
  local cycle = "main:currentCycle"

  system.updateStorage(day, system.getStorage(day)+1)
  if system.getStorage(day)-1 == #system.getStorage("main:route")[system.getStorage(cycle)] then
    system.updateStorage(cycle, system.getStorage(cycle)+1)
    system.updateStorage(day, 1)
  end
end