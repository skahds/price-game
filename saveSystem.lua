local binser = require "binser"
local objects = {}

function system.saveTable(id, t)
  objects[id] = t
end

function system.saveGame()
  local file = binser.serialize(objects)
  love.filesystem.write("save", file)
end

function system.loadGame()
  if not love.filesystem.getInfo("save") then return false end
  
  local fileData = love.filesystem.read("save")
  local success, file = pcall(binser.deserialize, fileData)
  
  if not success then 
    print("Deserialize error:", file)
    return false
  end

  local loadedObjects = file[1]
  
  for id, data in pairs(loadedObjects) do
    if objects[id] then
      for k, v in pairs(data) do
        objects[id][k] = v
      end
    end
  end
  
  return true
end