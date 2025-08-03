system.on("main:entityTriggered", function (ent)
  if ent.isNews == false then
    return
  end
  if ent.ui == nil then
    return
  end
  local ui = ent.ui

  local flux = system.getStorage("flux")
  local scaleFactor = 1.5
  local originalOx = ui.oy
  local originalOy = ui.oy
  local sx = ui.sx * scaleFactor
  local sy = ui.sy * scaleFactor
  local ox = ui.ox + (ui:getWidth()*scaleFactor-ui:getWidth())/4
  local oy = ui.oy + (ui:getHeight()*scaleFactor-ui:getHeight())/4
  flux.to(ui, 0.2, {sx = sx, sy=sy, ox=ox, oy=oy})
  main.wait(0.2, function ()
    flux.to(ui, 0.2, {sx = sx/scaleFactor, sy=sy/scaleFactor, ox=originalOx, oy=originalOy})
  end)

  local combo = system.getStorage("main:currentCombo") or 0
  local audio = system.playAudio("boop")
  main.audio.offsetAudioSourcePitch(audio, combo)
end)