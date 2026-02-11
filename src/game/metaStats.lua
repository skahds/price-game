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


-- to attach to entity, ie; card.unlock = {type="metashop"}

function main.meta.getLockedEntities(info)
  local t = {}
  for k, ent in pairs(main.entities) do
    local def = ent.definition
    local success = true
    if def == nil or def.unlock == nil then
      goto continue
    end
    if info.type and def.unlock and info.type == def.unlock.type then
      
    else
      success = false
    end

    if success == true then
      table.insert(t, ent)
    end

    ::continue::
  end

  return t
end

function main.meta.isEntityLocked(entID)
  local ent = main.entities[entID]
  if ent.definition and ent.definition.unlock then
    if stats.unlocks[entID] == true then
      return true
    else
      return false
    end
  else
    return true
  end
end