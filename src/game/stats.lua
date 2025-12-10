function main.resetStats()
  system.updateStorage("main:score", 0)
  system.updateStorage("main:mult", 1)
  system.updateStorage("main:energyPerTurn", 3)
  system.updateStorage("main:energy", 3)
  system.updateStorage("main:money", 0)
  system.updateStorage("shop:maxCardAmount", 3)
  system.updateStorage("shop:currentRerollPrice", 0)
  system.updateStorage("main:maxCardAmount", 5)
  system.updateStorage("main:roundsPerDay", 5)
  system.updateStorage("main:roundsRemaining", 5)
  system.updateStorage("main:currentDay", 1)
  system.updateStorage("main:scoreRequirement", 0)
  system.updateStorage("main:currentRoute", 1)
  system.updateStorage("main:currentDay", 1)
  system.updateStorage("main:isOnTurn", false)
  system.updateStorage("main:isDoingTutorial", false)
  system.updateStorage("main:tutorialInfos", {stage=1})
end

main.resetStats()

local stats = {"main:score", "main:mult", "main:energyPerTurn", "main:energy", "main:money", "shop:maxCardAmount", "main:maxCardAmount", "main:roundsPerDay", "main:roundsRemaining", "main:currentDay", "main:scoreRequirement", "main:currentRoute", "main:currentDay"
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