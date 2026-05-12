local isShown = false
local cover, back, guideSelectLeft, guideSelectRight, number
local currentPage = 1
-- , "-Placeable, cards with \"- News\" place news at mouse position", "-Relics, this will stay between encounters"
--image width, height = 400, 300
local pages = {
  {
    image="patternGuide",
    size={438, 200},
    text={"Patterns are formed if the","patterns-card matches the bar directions.","When the turn starts all cards","in the pattern will activate"}
  },  {
    image="scoreGuide",
    size={343, 200},
    text={"Score is gained after the round ends", "by the product of {priceIcon}{priceColor}PRICE{/priceColor} and {multIcon}{multColor}MULT{/multColor}", "({redColor}Negative{/redColor} {priceIcon}{priceColor}PRICE{/priceColor} still gives score)"}
  },  {
    image="newsGuide1",
    size={416, 211},
    text={"News are objects on the board", "There are 3 types of news","The first, Temporary, this will be deleted", "when the encounter ends"},
  },  {
    image="newsGuide2",
    size={456, 212},
    text={"The second, Placable", "cards with \"- News\" will place news", "at the mouse's position when activated"}
  },  {
    image="newsGuide3",
    size={466, 199},
    text={"The third, Relics", "these news are permanent", "and will stay between encounters"}
  },  {
    image="modificationGuide",
    size={600, 180},
    text={"Some modifications are temporary and reset after encounter", "Some modifications are permanent and stay between encounters", "{priceIcon}{priceColor}PRICE{/priceColor}, {multIcon}{multColor}MULT{/multColor}, {cardIcon}CARD, {moneyColor}${/moneyColor} changes are permanent", "{repeatIcon}{repeatColor}REPEAT{/repeatColor} are temporary"},
    font=system.getFont("defaultFont32")
  },  {
    image="energyGuide",
    size={430, 186},
    text={"{energyIcon}{energyColor}ENERGY{/energyColor} cost changes are temporary","unless stated otherwise", "and card with temporary {energyIcon}{energyColor}ENERGY{/energyColor} cost change","resets to normal cost after activated"},
  },  {
    image="objectiveGuide",
    size={391, 200},
    text={"Objectives are optional challenges", "That give the reward listed below them", "if you manage to complete them"}
  },  {
    image="guideGuide",
    size={389, 200},
    text={"You can open this guide", "Through the ? button in settings."}
  },
}

local function deleteAll(args)
  if args == nil then return end
  for k, ent in pairs(args) do
    if type(ent) == "table" and ent.delete then
      ent:delete()
    end
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
local width = 800
local height = 500

main.defineUITab("guide", function ()
  isShown = true
  cover = main.ui.spawnUI("cover", {
    x=dimension.w/2-width/2,
    y=dimension.h/2-height/2,
    width = width,
    height = height,
    color = {0.6, 0.6, 0.6},
    outline = 10,
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
    x=dimension.w/2-width/8-40,
    y=dimension.h/2+height/3-40+20,
    renderLayer = 392,
    text="<",
    onButtonClicked = function ()
      buttonClick(-1)
    end
  })

  guideSelectRight = main.ui.spawnUI("guideSelect", {
    x=dimension.w/2+width/8-40,
    y=dimension.h/2+height/3-40+20,
    renderLayer = 392,
    text=">",
    onButtonClicked = function ()
      buttonClick(1)
    end
  })
  
  number = main.newRichText({format="0",
    x=0,
    y=0,
    renderLayer = 392,
    outline=true,
    outlineColor={0,0,0},})
end, function ()
  deleteAll({cover, back, guideSelectLeft, guideSelectRight, number})
  isShown = false
end)

system.on("@update", function ()
  if number == nil then
    return
  end
  number.x = dimension.w/2 - number.richText:getWidth()/2
  number.y = dimension.h/2+height/3 - number.richText:getHeight()/2/2
  main.updateRichTextText(number, currentPage .. "/" .. #pages)
end)

system.on("@draw", function ()
  if isShown == false then
    return
  end

  local page = pages[currentPage]
  local w, h = page.size[1], page.size[2]
  local x, y = dimension.w/2-w/2, dimension.h/2 - height/2+30
  if page.image then
    system.render(392, function ()
      love.graphics.setColor(1, 1, 1)
      love.graphics.draw(system.getImage(page.image), x, y)
    end, true)
  end

  for i, text in ipairs(page.text) do
    local t = main.printRichText({
      format = text,
      x=0,
      y=y+h+10,
      renderLayer = 392,
      outline=true,
      outlineColor={0,0,0},
      font= page.font or system.getFont("defaultFont40")
    })
    t.y = t.y + t.richText:getHeight()*(i-1)
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
    main.openUITab("guide", false)
  end
})

main.ui.defineButton("guideSelect", {
  width = 60,
  height = 60,
  color = {0.7, 0.4, 0.4},
  renderLayer = 101,
  screenSpace = true,
  audio = "breaker",
})