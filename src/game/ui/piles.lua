local discardPileText = main.newRichText({format="0",
  x=0,
  y=505,
  renderLayer = 200,})

local drawPileText = main.newRichText({format="0",
  x=0,
  y=455,
  renderLayer = 200,})

system.on("@draw", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    return
  end

  system.render(280, function ()
    love.graphics.draw(system.getImage("discardPile"), 1100, 500)
    love.graphics.draw(system.getImage("drawPile"), 1100, 450)
  end, true)
end)

system.on("@update", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    discardPileText.x = -100
    drawPileText.x = -100
    return
  end

  discardPileText.x = 1170
  drawPileText.x = 1170
  local c = #main.card.discard
  main.updateRichTextText(discardPileText, c)
  local d = #main.card.draw
  main.updateRichTextText(drawPileText, d)
end)