local componentList = {}

function main.defineComponent(name, defaultValue)
  componentList[name] = defaultValue
end

function main.isComponent(name)
  if componentList[name] ~= nil then
    return true
  end
  return false
end

-- for json
function main.getAllComponentsFromEntity(ent)
  local t = {}
  for id, defaultValue in pairs(componentList) do
    if ent[id] ~= defaultValue then
      t[id] = ent[id]
    end
  end
  t.id = ent.id
  return t
end

system.on("main:entitySpawned", function (ent)
  for k, v in pairs(componentList) do
    if ent[k] == nil then
      ent[k] = utils.deepCopy(v)
    end
  end
end)

system.on("ui:spawnedUI", function (ent)
  for k, v in pairs(componentList) do
    if ent[k] == nil then
      ent[k] = utils.deepCopy(v)
    end
  end
end)