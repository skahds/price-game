local isShown = false
local cover, back, guideSelectLeft, guideSelectRight, number
local currentPage = 1

--image width, height = 400, 300
local pages = {
  {
    image="guideLogo",
    size={316, 200},
    text={"Welcome, in this game, you", "try to get lots of score", "by changing {priceColor}PRICES{/priceColor} and {multColor}MULTS"}
  },  {
    image="guideRound",
    size={459, 150},
    text={"Decide if you think the", "price will go up or down,", "these will give you score"}
  },  {
    image="guideHand",
    size={393, 187},
    text={"This is your hand,", "Your cards go here,", "You can play cards from here"}
  },  {
    image="energyGuide",
    size={438, 200},
    text={"Most cards uses {energyColor}energy,", "You replenish {energyColor}energy{/energyColor} at the", "end of turn"}
  },  {
    image="chartGuide",
    size={503, 200},
    text={"The chart contains news", "which activates when", "the turn starts"}
  },  {
    image="guideShop",
    size={300, 189},
    text={"You can upgrade your", "run in the shop", "by {moneyColor}buying{/moneyColor} cards!"}
  }
}

local function deleteAll(arg)
  for k, ent in ipairs(arg) do
    ent:delete()
  end
end

local function buttonClick(n)
  currentPage=currentPage+n
  if currentPage > #pages then
    currentPage = 1
  elseif currentPage < 1 then
    currentPage = #pages
  end
end

local dimension = system.getStorage("screenDimension")
local width = 700
local height = 500

function main.ui.guidebook()
  if isShown == false then
    isShown = true
    cover = main.ui.spawnUI("cover", {
      x=dimension.w/2-width/2,
      y=dimension.h/2-height/2,
      width = width,
      height = height,
      color = {0.6, 0.6, 0.6},
      outline = 20,
      rx=20,
      ry=20,
      outlineColor = {0.4, 0.4, 0.4},
      ignoreUIChecks = false,
      renderLayer = 390})

    back = main.ui.spawnUI("guideBack", {
      x=dimension.w/2+width/2-40-40,
      y=dimension.h/2-height/2+20,
      renderLayer = 392,
    })

    guideSelectLeft = main.ui.spawnUI("guideSelect", {
      x=dimension.w/2-width/4-40,
      y=dimension.h/2+height/3-40,
      renderLayer = 392,
      text="<",
      onButtonClicked = function ()
        buttonClick(-1)
      end
    })

    guideSelectRight = main.ui.spawnUI("guideSelect", {
      x=dimension.w/2+width/4-40,
      y=dimension.h/2+height/3-40,
      renderLayer = 392,
      text=">",
      onButtonClicked = function ()
        buttonClick(1)
      end
    })
    
    number = main.newRichText({format="0",
      x=0,
      y=0,
    renderLayer = 392,})
  else
    deleteAll({cover, back, guideSelectLeft, guideSelectRight, number})
    isShown = false
  end
end

system.on("@update", function ()
  if number == nil then
    return
  end
  number.x = dimension.w/2 - number.richText:getWidth()/2
  number.y = dimension.h/2+height/3 - number.richText:getHeight()/2
  main.updateRichTextText(number, currentPage .. "/" .. #pages)
end)

system.on("@draw", function ()
  if isShown == false then
    return
  end

  local page = pages[currentPage]
  local w, h = page.size[1], page.size[2]
  local x, y = dimension.w/2-w/2, dimension.h/2 - height/2+30
  system.render(392, function ()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(system.getImage(page.image), x, y)
  end, true)

  for i, text in ipairs(page.text) do
    local t = main.printRichText({
      format = text,
      x=0,
      y=y+h+10+40*(i-1),
      renderLayer = 392
    })
    t.x = dimension.w/2-t.richText:getWidth()/2
  end
end)

main.ui.defineButton("guideBack", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  text = "X",
  audio = "breaker",
  onButtonClicked = function (ent)
    main.ui.guidebook()
  end
})

main.ui.defineButton("guideSelect", {
  width = 80,
  height = 80,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  audio = "breaker",
})