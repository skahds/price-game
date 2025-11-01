-- hard coded
local originalScale = 1.7

system.on("main:entityTriggered", function (ent)
  if ent.ui and ent.isCard then
    local cardUI = ent.ui

    local flux = system.getStorage("flux")
    local scaleFactor = 1.5
    local sx = originalScale * scaleFactor
    local sy = originalScale * scaleFactor
    local ox = cardUI.width/2
    local oy = cardUI.height/2
    flux.to(cardUI, 0.15, {sx = sx, sy=sy, ox=ox, oy=oy})
    :after(cardUI, 0.15, {sx = originalScale, sy=originalScale, ox=0, oy=0})
    
    local combo = system.getStorage("main:currentCombo") or 0
    local audio = system.playAudio("boop")
    main.audio.offsetAudioSourcePitch(audio, math.min(combo, 12))
  end
end)