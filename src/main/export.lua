main.world = {}
main.deleteQueue = {}

function main.spawnEntity(id, args)
  if main.entities[id] == nil then
    error("unknown entity " .. id)
  end
  table.insert(main.world, main.entities[id]:new(args))
  local entity =  main.world[#main.world]
  entity.index = #main.world

  system.call("main:entitySpawned", entity)

  return main.world[#main.world]
end