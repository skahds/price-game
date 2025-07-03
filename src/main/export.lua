main.world = {}
main.deleteQueue = {}

function main.spawnEntity(id, args, ret)
  table.insert(main.world, main.entities[id]:new(args))
  main.world[#main.world].index = #main.world

  if ret then
    return main.world[#main.world]
  end
end