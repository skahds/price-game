main.meta = {}
-- stats that carry over runs
local stats = {
  credits = 0,
  unlocks = {},
  achievement = {},
}

function main.meta.saveMetaStats()
  system.writeFileTable("metastats", stats)
end

system.on("@load", function ()
  local s = system.readFileTable("metastats")
  if s then
    for k, v in pairs(s) do
      stats[k] = v
    end
  end
  
  for k, achievement in pairs(stats.achievement) do
    Steam.userStats.setAchievement(achievement)
  end
  Steam.userStats.storeStats()
end)

function main.meta.getTable()
  return stats
end

function main.meta.giveCredits(n)
  stats.credits = stats.credits + n
  main.meta.saveMetaStats()
end

function main.meta.checkIsUnlockedStats(k)
  if stats.unlocks[k] == true then
    return true
  else
    return false
  end
end

function main.meta.checkIsUnlockedAchievement(f)
  if stats.achievement[f] == true then
    return true
  else
    return false
  end
end

function main.meta.unlock(k)
  stats.unlocks[k] = true
  main.meta.saveMetaStats()
end

function main.meta.giveAchievement(name)
  Steam.userStats.setAchievement(name)
  stats.achievement[name] = true
end