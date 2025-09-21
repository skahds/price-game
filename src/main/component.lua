local componentList = {}

function main.defineComponent(name, defaultValue)
  componentList[name] = defaultValue
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