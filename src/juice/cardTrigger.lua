system.on("main:entityTriggered", function (ent)
  if ent.cardUI then
    local cardUI = ent.cardUI

    local flux = system.getStorage("flux")
    local sx = cardUI.sx * 1.5
    local sy = cardUI.sy * 1.5
    local originalOx = cardUI.oy
    local originalOy = cardUI.oy
    local ox = cardUI.ox+cardUI.width*sx/10
    local oy = cardUI.oy+cardUI.width*sy/10
    flux.to(cardUI, 0.2, {sx = sx, sy=sy, ox=ox, oy=oy})
    main.wait(0.2, function ()
      flux.to(cardUI, 0.2, {sx = sx/1.5, sy=sy/1.5, ox=originalOx, oy=originalOy})
    end)

    -- main.playAudio("boop")
  end
end)