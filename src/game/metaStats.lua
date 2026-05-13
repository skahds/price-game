main.meta = {}
-- stats that carry over runs
local stats = {
  credits = 0,
  unlocks = {},
  achievement = {},
  metashopItems = {},
  stats={}
}
local amountOfMetaItem = 4

function main.meta.saveMetaStats()
  system.writeFileTable("metastats", stats)
end

local bag = {}
local function rebuildBag(exclude)
  bag = {}
  local t = main.meta.getLockedEntities{type="metashop"}
  for _, ent in pairs(t) do
    local id = ent.definition.id
    local excluded = false
    if exclude then
      for _, ex in ipairs(exclude) do
        if ex == id then
          excluded = true
          break
        end
      end
    end
    if not excluded then
      table.insert(bag, id)
    end
  end
end

-- Picks up to n items from bag without duplicates, safe if bag has fewer than n
local function drawFromBag(n)
  local drawn = {}
  local toDraw = math.min(n, #bag)
  for i = 1, toDraw do
    local rand = love.math.random(1, #bag)
    table.insert(drawn, bag[rand])
    table.remove(bag, rand)
  end
  return drawn
end

system.on("@load", function()
  local s = system.readFileTable("metastats")
  if s then
    for k, v in pairs(s) do
      stats[k] = v
    end
  end

  -- Remove any saved metashop items that have since been unlocked
  if stats.metashopItems then
    for i = #stats.metashopItems, 1, -1 do
      if main.meta.isEntityUnlocked(stats.metashopItems[i]) then
        table.remove(stats.metashopItems, i)
      end
    end
  end

  -- Build bag excluding items already in the shop
  rebuildBag(stats.metashopItems)

  local totalAvailable = #bag + #(stats.metashopItems or {})
  local targetCount = math.min(amountOfMetaItem, totalAvailable)

  -- Top up shop slots if needed (fresh save, or slots were consumed)
  if stats.metashopItems == nil then
    stats.metashopItems = {}
  end

  if #stats.metashopItems < targetCount then
    local needed = targetCount - #stats.metashopItems
    local drawn = drawFromBag(needed)
    for _, id in ipairs(drawn) do
      table.insert(stats.metashopItems, id)
    end
  end

  main.meta.saveMetaStats()

  if Steam then
    if isDemo == false  then
      for k, achievement in pairs(stats.achievement) do
        Steam.userStats.setAchievement(k)
      end
    end
    Steam.userStats.storeStats()
  end
end)


function main.meta.getTable()
  return stats
end

function main.meta.getStats(id)
  return stats.stats[id]
end

function main.meta.updateStats(id, newVar)
  if type(id) ~= "string" then
    error("id must be string " .. id)
  end
  
  stats.stats[id] = newVar
  main.meta.saveMetaStats()
end

function main.meta.getCredits()
  return stats.credits
end

function main.meta.giveCredits(n)
  stats.credits = stats.credits + n
  
  if n > 0 then
    local currentTotal = main.meta.getStats("totalCreditsEarned") or 0
    main.meta.updateStats("totalCreditsEarned", currentTotal + n)
  end

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

function main.meta.unlockItem(k)
  stats.unlocks[k] = true

  -- Remove from shop
  for i, item in ipairs(stats.metashopItems) do
    if item == k then
      table.remove(stats.metashopItems, i)
      break
    end
  end

  -- Replenish bag if empty, excluding current shop contents
  if #bag == 0 then
    rebuildBag(stats.metashopItems)
  end

  -- Only draw a replacement if something is available
  if #bag > 0 then
    local rand = love.math.random(1, #bag)
    table.insert(stats.metashopItems, bag[rand])
    table.remove(bag, rand)
  end

  main.meta.saveMetaStats()
end


function main.meta.giveAchievement(name)
  if Steam and isDemo == false then
    Steam.userStats.setAchievement(name)
    stats.achievement[name] = true
  end
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
    if main.meta.isEntityUnlocked(def.id) then
      goto continue
    end
    if isDemo and def.unlock.demoAvailable ~= true  then
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

function main.meta.isEntityUnlocked(entID)
  local ent = main.entities[entID]
  if ent.definition and ent.definition.unlock then
    if isDemo and ent.definition.unlock.demoAvailable ~= true then
      return false
    end
    if stats.unlocks[entID] == true then
      return true
    else
      return false
    end
  else
    return true
  end
end


--metashop
system.on("@load", function ()

end)

function main.meta.getMetashopItems()
  return stats.metashopItems
end