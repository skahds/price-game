local json = require "json"
local saves = {}
local loads = {}

function system.onSave(id, func)
  saves[id] = func
end

function system.onLoad(id, func)
  loads[id] = func
end

function system.saveGame()
  local t = {}
  for id, func in pairs(saves) do
    t[id] = func()
  end
  local obj = json.encode(t)
  love.filesystem.write("save", obj)
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

  for id, loadFunc in pairs(loads) do
    loadFunc(obj[id])
  end
end