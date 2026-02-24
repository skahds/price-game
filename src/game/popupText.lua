local flux = system.getStorage("flux")
--sort of a helper function, not sure if i should put this in a sepearte file
function main.createPopupText(info)
  info.lifetime = info.lifetime or 1
  for i, text in ipairs(info.text) do
    local t = main.newRichText({
      format=text,
      x=info.startX or info.x,
      y=info.startY or info.y,
      renderLayer=info.renderLayer or 100,
      font = info.font or nil,
      outline = info.outline,
      outlineColor = info.outlineColor,
    })
    local yOffset = t.richText:getHeight()*((i-0.5)-#info.text/2)
    local xOffset = -t.richText:getWidth()/2
    t.y = t.y + yOffset
    t.x = t.x + xOffset
    
    if info.timeMomentaryStill then
      local timeBetweenFlux = (info.lifetime-info.timeMomentaryStill)/2
      local targetX = (info.targetX or (t.x-xOffset)) + xOffset
      local targetY = (info.targetY or (t.y-yOffset)) + yOffset
      flux.to(t, timeBetweenFlux, {x=targetX, y=targetY}):ease("backout"):after(info.timeMomentaryStill, {}):after(timeBetweenFlux, {x=(info.startX or info.x)+xOffset, y=(info.startY or info.y)+yOffset}):ease("backin")
    end

    main.wait(info.lifetime, function ()
      t:delete()
    end)
  end
end