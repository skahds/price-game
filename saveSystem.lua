local json = require "json"
local saves = {}
local loads = {}
local orders = {}

function system.register(id, order, saveFunc, loadFunc)
  if saves[id] then
    error("Save ID already registered: " .. id)
  end
  
  saves[id] = saveFunc
  loads[id] = loadFunc
  orders[id] = order
end

function system.saveGame()
  local t = {}

  for id, func in pairs(saves) do
    local success, result = pcall(func)
    if success then
      t[id] = result
    else
      print("Error saving " .. id .. ": " .. result)
      return false
    end
  end
  
  local success, obj = pcall(json.encode, t)
  if not success then
    print("Error encoding save data: " .. obj)
    return false
  end
  
  local success, err = love.filesystem.write("save", obj)
  if not success then
    print("Error writing save file: " .. err)
    return false
  end
  
  return true
end

function system.loadGame()
  if not love.filesystem.getInfo("save") then
    return false
  end

  local save = love.filesystem.read("save")
  if not save then
    return false
  end

  local success, obj = pcall(json.decode, save)
  if not success then
    print("Corrupted save file")
    return false
  end

  local sortedIds = {}
  for id in pairs(loads) do
    table.insert(sortedIds, id)
  end
  
  table.sort(sortedIds, function(a, b)
    return (orders[a] or 0) < (orders[b] or 0)
  end)

  for _, id in ipairs(sortedIds) do
    local loadFunc = loads[id]
    local success, err = pcall(loadFunc, obj[id])
    if not success then
      print("Error loading " .. id .. ": " .. err)
    end
  end
  
  return true
end