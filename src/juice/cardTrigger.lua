system.on("main:entityTriggered", function (ent)
  if ent.cardUI then
    local cardUI = ent.cardUI

    local flux = system.getStorage("flux")
    local scaleFactor = 1.5
    local sx = cardUI.sx * scaleFactor
    local sy = cardUI.sy * scaleFactor
    local originalOx = cardUI.oy
    local originalOy = cardUI.oy
    local ox = cardUI.ox + (cardUI:getWidth()*scaleFactor-cardUI:getWidth())/4
    local oy = cardUI.oy + (cardUI:getHeight()*scaleFactor-cardUI:getHeight())/4
    flux.to(cardUI, 0.2, {sx = sx, sy=sy, ox=ox, oy=oy})
    main.wait(0.2, function ()
      flux.to(cardUI, 0.2, {sx = sx/scaleFactor, sy=sy/scaleFactor, ox=originalOx, oy=originalOy})
    end)
  end

  local combo = system.getStorage("main:currentCombo") or 0
  local audio = system.playAudio("boop")
  main.audio.offsetAudioSourcePitch(audio, combo)
end)