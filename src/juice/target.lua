local flux = system.getStorage("flux")
local obj = {}

system.on("main:targetEntityTriggered", function (ent, targetEnt)
  local t = {x=ent.x+ent.width/2, y=ent.y+ent.height/2}
  t.index = #obj
  table.insert(obj, t)
  flux.to(t, 0.4, {x=targetEnt.x+targetEnt.width/2, y=targetEnt.y+targetEnt.height/2})

  main.wait(0.4, function ()
    for i, n in ipairs(obj) do
      if n.index == t.index then
        table.remove(obj, i)
        break
      end
    end
  end)
end)

system.on("@draw", function ()
  system.render(60, function ()
    for i, n in ipairs(obj) do
      love.graphics.draw(system.getImage("target"), n.x-16, n.y-16)
    end
  end)
end)