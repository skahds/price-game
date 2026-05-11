local font = system.getFont("defaultFont80")
local discardPileText = main.newRichText({format="0",
  x=0,
  y=720-50,
  outline=true,
  outlineColor={0.4, 0.4, 0.4},
  font=font,
  renderLayer = 281,})

local drawPileText = main.newRichText({format="0",
  x=0,
  y=720-50,
  outline=true,
  outlineColor={0.4, 0.4, 0.4},
  font=font,
  renderLayer = 281,})

system.on("@update", function ()
  local scene = system.getStorage("main:currentScene")
  if scene ~= "play" then
    discardPileText.isVisible = false
    drawPileText.isVisible = false
    return
  end
  discardPileText.isVisible = true
  drawPileText.isVisible = true

  discardPileText.ox = discardPileText.richText:getWidth()/2
  discardPileText.oy= discardPileText.richText:getHeight()/2
  drawPileText.ox = drawPileText.richText:getWidth()/2
  drawPileText.oy= drawPileText.richText:getHeight()/2

  discardPileText.x = 60+20
  drawPileText.x = 1280-60-20
  local c = #main.card.discard
  main.updateRichTextText(discardPileText, c)
  local d = #main.card.draw
  main.updateRichTextText(drawPileText, d)
end)


local flux = system.getStorage("flux")
local showingDraw = false
local showingDiscard = false
local info = {t=0, cards={}}

system.on("@update", function ()
  if showingDraw or showingDiscard then
    flux.to(info, 0.2, {t=1})
  else
    flux.to(info, 0.2, {t=0})
  end
end)

system.on("@draw", function ()
  if (showingDraw or showingDiscard) == false then
    return
  end

  local x
  if showingDraw then
    x = 1280-80
  else
    x = 80
  end

  for i=#info.cards, 1, -1 do
    local card = info.cards[i]
    local gap = math.max(20, 70-i*2)
    local image = system.getImage(card.image)
    local y = 720-80-i*gap*info.t
    system.render(279, function ()
      love.graphics.draw(image, x, y, 0, 1.4, 1.4, 32, 32)
    end, true)
  end
end)

local function updatePile(pileName)
  info.cards = {}

  for i, card in ipairs(main.card[pileName]) do
    table.insert(info.cards, card)
  end
  
  utils.shuffle(info.cards)
end

system.on("main:cardTransferedOwnership", function ()
  info.t = info.t*3/4

  if showingDraw then
    updatePile("draw")
  elseif showingDiscard then
    updatePile("discard")
  end
end)

main.ui.defineUI("drawPile", {
  image="drawPile",
  description = "Draw pile",
  showDescription=true,
  width = 48,
  height = 48,
  ox=24,
  oy=24,
  sx=1.3,
  sy=1.3,
  renderLayer = 280,
  screenSpace = true,

  onHover = function ()
    if showingDraw == false then
      updatePile("draw")
    end

    showingDraw=true
  end,
  notHovered = function ()
    showingDraw=false
  end
})

main.ui.defineUI("discardPile", {
  image = "discardPile",
  description = "Discard pile",
  showDescription=true,
  width = 48,
  height = 48,
  ox=24,
  oy=24,
  sx=1.3,
  sy=1.3,
  renderLayer = 280,
  screenSpace = true,

  onHover = function ()
    if showingDiscard == false then
      updatePile("discard")
    end

    showingDiscard=true
  end,
  notHovered = function ()
    showingDiscard=false
  end
})