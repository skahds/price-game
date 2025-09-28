-- hard coded
local originalScale = 1

system.on("main:entityTriggered", function (ent)
  if ent.isNews ~= true then
    return
  end
  if ent.ui == nil then
    return
  end
  local ui = ent.ui

  local flux = system.getStorage("flux")
  local scaleFactor = 1.5
  local sx = originalScale * scaleFactor
  local sy = originalScale * scaleFactor
  local ox = ui.ox + (ui:getWidth()*scaleFactor-ui:getWidth())/4
  local oy = ui.oy + (ui:getHeight()*scaleFactor-ui:getHeight())/4
  flux.to(ui, 0.15, {sx = sx, sy=sy, ox=ox, oy=oy})
  :after(ui, 0.15, {sx = originalScale, sy=originalScale, ox=0, oy=0})

  main.tweenCamera(0.2, {x=ui.x+ui:getWidth()/2, y=ui.y+ui:getHeight()/2})

  local combo = system.getStorage("main:currentCombo") or 0
  local audio = system.playAudio("boop")
  main.audio.offsetAudioSourcePitch(audio, combo)
end)