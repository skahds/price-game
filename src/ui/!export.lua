main.ui = {
  world = {},
  deleteQueue = {},
  entities = {}
}

function main.ui.spawnUI(id, args)
  local ent = main.ui.entities[id]:new(args)
  table.insert(main.ui.world, ent)
  ent.index = #main.ui.world
  system.call("ui:spawnedUI", ent)
  
  return ent
end