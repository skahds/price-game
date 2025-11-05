system.on("main:entityTriggered", function (ent)
  if ent.spawnNews then
    local mouse = system.getStorage("mouse")
    local x, y = main.grid.snapToGrid(mouse.x, mouse.y)
    local x, y = main.grid.getClosestAvailableGrid(x, y, 1, 1)
    local x, y = main.grid.gridToPos(x, y)
    local news = main.spawnNews(ent.spawnNews, {x=mouse.x, y=mouse.y})
    if ent.newsEffect then
      ent.newsEffect(ent, news)
    end
  end
end)