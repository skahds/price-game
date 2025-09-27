-- card bought juice
system.on("main:cardTransferedOwnership", function (card, oldOwnerShip, newOwnership)
  if oldOwnerShip ~= "shop" then
    return
  end

  local form
  local cardUI = card.ui
  if card.price > 0 then
    form = "{redColor}-$" .. card.price .. "{/redColor}"
  else
    form = "{moneyColor}+$" .. card.price .. "{/moneyColor}"
  end
  
  local size = love.math.random()+2
  
  local text = main.newRichText({format=form,
  x=cardUI.x + love.math.random(-20, 20),
  y=cardUI.y+cardUI:getHeight() + love.math.random(-30, 30),
  r=(love.math.random()-0.5)*math.pi/3,
  sx=size,
  sy=size,
  outline = true,
  screenSpace = true,
  renderLayer = 300,})
  text.ox = text.richText:getWidth()/2
  text.oy = text.richText:getHeight()/2

  local flux = system.getStorage("flux")
  local randomSpin = (love.math.random()-0.5)*3
  local randomSizeIncrease = love.math.random()
  flux.to(text, 0.3, {r=text.r+randomSpin})
  flux.to(text, 0.5, {sx=size+randomSizeIncrease, sy=size+randomSizeIncrease})
  
  system.playAudio("boop")

  main.waitWithMult(0.2, function ()
    text:delete()
  end)
end)

-- card prices juice
system.on("@draw", function ()
  for i, card in ipairs(main.card.shop) do
    local ui = card.ui
    local width, height = ui:getWidth(), ui:getHeight()
    if card.price then
      local richText = main.printRichText({format="{moneyColor}$" .. card.price,
      x=ui.x+width/2,
      y=ui.y+height-10,
      renderLayer = 300,
      })
      local richTextWidth = richText.richText:getWidth()
      richText.x = richText.x - richTextWidth/2
    end
  end
end)