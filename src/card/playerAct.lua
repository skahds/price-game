local player = {}

system.on("mouse:moved", function (t)
  local dx, dy = t.dx, t.dy
  local mouse = system.getStorage("realMouse")
  local uiEnt = player.cardSelected
  if uiEnt then
    uiEnt.x = uiEnt.x + dx
    uiEnt.y = uiEnt.y + dy
  end
end)

system.on("main:cardHovered", function (ent)
  if love.mouse.isDown(1) then
    player.cardSelected = ent.cardUI
  end
end)

system.on("main:cardReleased", function (ent)
  if player.cardSelected then
    player.cardSelected = nil
  end
end)

system.on("@mouse:released", function (button)
  player.cardSelected = nil
end)